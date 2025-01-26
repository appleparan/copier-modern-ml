from pathlib import Path

import lightning as L  # noqa: N812
import torch
from datasets import load_dataset
from torch.utils.data import DataLoader
from transformers import (
    AdamW,
    AutoModelForSequenceClassification,
    AutoTokenizer,
    PreTrainedTokenizer,
)
from transformers.modeling_outputs import SequenceClassifierOutput


class TinyBertClassifier(L.LightningModule):
    """A PyTorch Lightning Module for text classification using a Tiny BERT model.

    Attributes:
        model_name (str): HuggingFace model name.
        num_labels (int): Number of labels in the dataset.
        lr (float): Learning rate for the optimizer.
        model: HuggingFace AutoModelForSequenceClassification instance.
    """

    def __init__(self, model_name: str, num_labels: int = 2, lr: float = 2e-5):
        """Initialize the TinyBertClassifier.

        Args:
            model_name (str): The name of the pre-trained model from HuggingFace.
            num_labels (int, optional): Number of classification labels. Defaults to 2.
            lr (float, optional): Learning rate for the optimizer. Defaults to 2e-5.
        """
        super().__init__()
        self.save_hyperparameters()
        self.model = AutoModelForSequenceClassification.from_pretrained(
            model_name, num_labels=num_labels
        )
        self.lr = lr

    def forward(
        self,
        input_ids: torch.Tensor,
        attention_mask: torch.Tensor,
        labels: torch.Tensor | None = None,
        token_type_ids: torch.Tensor | None = None,
    ) -> SequenceClassifierOutput:
        """Perform a forward pass through the model.

        Args:
            input_ids (torch.Tensor): Tensor of token IDs.
            attention_mask (torch.Tensor): Tensor of attention masks.
            labels (torch.Tensor, optional):
                Tensor of labels. Defaults to None.
            token_type_ids (torch.Tensor, optional):
                Tensor of token type IDs. Defaults to None.

        Returns:
            SequenceClassifierOutput:
                The model output from HuggingFace's AutoModelForSequenceClassification.
        """
        return self.model(
            input_ids=input_ids,
            attention_mask=attention_mask,
            labels=labels,
            token_type_ids=token_type_ids,
        )

    def training_step(
        self,
        batch: tuple[dict[str, torch.Tensor], torch.Tensor],
        batch_idx: int,  # noqa: ARG002
    ) -> torch.Tensor:
        """Perform a training step.

        Args:
            batch (tuple[dict[str, torch.Tensor], torch.Tensor]):
                The input batch containing features and labels.
            batch_idx (int): The index of the batch.

        Returns:
            torch.Tensor: The computed training loss.
        """
        inputs = batch
        outputs = self(
            inputs['input_ids'],
            attention_mask=inputs['attention_mask'],
            labels=inputs['labels'],
        )
        loss = outputs.loss
        self.log('train_loss', loss)
        return loss

    def validation_step(
        self,
        batch: tuple[dict[str, torch.Tensor], torch.Tensor],
        batch_idx: int,  # noqa: ARG002
    ) -> torch.Tensor:
        """Perform a validation step.

        Args:
            batch (tuple[dict[str, torch.Tensor], torch.Tensor]):
                    The input batch containing features and labels.
            batch_idx (int): The index of the batch.

        Returns:
            torch.Tensor: The computed validation loss.
        """
        inputs = batch
        outputs = self(
            inputs['input_ids'],
            attention_mask=inputs['attention_mask'],
            labels=inputs['labels'],
        )
        val_loss = outputs.loss
        preds = torch.argmax(outputs.logits, dim=1)
        acc = (preds == inputs['labels']).float().mean()
        self.log('val_loss', val_loss, prog_bar=True)
        self.log('val_acc', acc, prog_bar=True)
        return val_loss

    def test_step(
        self,
        batch: tuple[dict[str, torch.Tensor], torch.Tensor],
        batch_idx: int,  # noqa: ARG002
    ) -> torch.Tensor:
        """Perform a validation step.

        Args:
            batch (tuple[dict[str, torch.Tensor], torch.Tensor]):
                    The input batch containing features and labels.
            batch_idx (int): The index of the batch.

        Returns:
            torch.Tensor: The computed validation loss.
        """
        inputs = batch
        outputs = self(
            inputs['input_ids'],
            attention_mask=inputs['attention_mask'],
            labels=inputs['labels'],
        )
        test_loss = outputs.loss
        preds = torch.argmax(outputs.logits, dim=1)
        acc = (preds == inputs['labels']).float().mean()
        self.log('test_loss', test_loss, prog_bar=True)
        self.log('test_acc', acc, prog_bar=True)
        return test_loss

    def configure_optimizers(self) -> AdamW:
        """Configure the optimizer for the model.

        Returns:
            AdamW: The AdamW optimizer.
        """
        return AdamW(self.parameters(), lr=self.lr)


def prepare_data(
    tokenizer: PreTrainedTokenizer, max_length: int = 512
) -> tuple[torch.utils.data.Dataset, torch.utils.data.Dataset]:
    """Prepares the training and validation datasets for the BoolQ task.

    Args:
        tokenizer (PreTrainedTokenizer):
            A tokenizer instance from the HuggingFace Transformers library.
        max_length (int, optional):
            The maximum sequence length for tokenization. Defaults to 512.

    Returns:
        tuple[torch.utils.data.Dataset, torch.utils.data.Dataset]:
            A tuple containing the training dataset and validation dataset.
    """
    # Load a subset of the BoolQ dataset
    _train_ds = load_dataset('boolq', split='train[:4000]')
    _val_ds = load_dataset('boolq', split='validation[:1000]')
    _test_ds = load_dataset('boolq', split='validation[1000:2000]')

    # Tokenize the data
    def preprocess(examples):  # noqa: ANN001, ANN202
        tokenized_inputs = tokenizer(
            examples['question'],
            examples['passage'],
            max_length=max_length,
            truncation=True,
            padding='max_length',
            return_tensors='pt',
        )

        labels = [1 if ans else 0 for ans in examples['answer']]

        tokenized_inputs['labels'] = labels

        return tokenized_inputs

    tokenized_train = _train_ds.map(preprocess, batched=True)
    tokenized_val = _val_ds.map(preprocess, batched=True)
    tokenized_test = _test_ds.map(preprocess, batched=True)

    # Convert to PyTorch-compatible datasets
    train_dataset = tokenized_train
    val_dataset = tokenized_val
    test_dataset = tokenized_test

    return train_dataset, val_dataset, test_dataset


def train_boolq(
    root_dir: Path,
    max_epochs: int = 10,
    accelerator: str = 'auto',
    devices: int | str | list[int] = 'auto',
    deterministic: bool = True,  # noqa: FBT001, FBT002
    random_seed: int = 42,
) -> None:
    """Train boolq datasets with BERT tiny model.

    Args:
        root_dir (Path): Default path for logs and weights.
        max_epochs (int, optional):
            Stop training once this number of epochs is reached.
            Defaults to 10.
        accelerator (str, optional):
            Supports passing different accelerator types.
            Defaults to "auto".
        devices (int, optional):
            Number of devices to train on. Defaults to "auto".
        deterministic (bool, optional):
            Sets the `torch.backends.cudnn.deterministic` flag.
            Defaults to True.
        random_seed (int, optional):
            Random seed for reproducibility. Defaults to 42.
    """
    L.seed_everything(random_seed, workers=True)

    model_name = 'google/bert_uncased_L-2_H-128_A-2'  # BERT Tiny model
    tokenizer = AutoTokenizer.from_pretrained(model_name)

    train_dataset, val_dataset, test_dataset = prepare_data(tokenizer)

    # Convert to torch Dataset
    train_dataset.set_format(
        type='torch', columns=['input_ids', 'attention_mask', 'labels']
    )
    val_dataset.set_format(
        type='torch', columns=['input_ids', 'attention_mask', 'labels']
    )
    test_dataset.set_format(
        type='torch', columns=['input_ids', 'attention_mask', 'labels']
    )

    # Set DataLoader
    train_loader = DataLoader(train_dataset, batch_size=16, shuffle=True)
    val_loader = DataLoader(val_dataset, batch_size=16)
    test_loader = DataLoader(test_dataset, batch_size=16)

    # Setup model and trainer
    model = TinyBertClassifier(model_name=model_name)
    trainer = L.Trainer(
        default_root_dir=root_dir,
        max_epochs=max_epochs,
        accelerator=accelerator,
        devices=devices,
        deterministic=deterministic,
        log_every_n_steps=10,
    )
    trainer.fit(model, train_loader, val_loader)
    trainer.test(model, test_loader)
