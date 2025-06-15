from pathlib import Path

import lightning as L  # noqa: N812
import torch
from torch import nn
from torch.utils.data import DataLoader, random_split
from torchvision import datasets, transforms


class MNISTClassifier(L.LightningModule):
    """A PyTorch Lightning Module for MNIST classification.

    Attributes:
        lr (float): Learning rate for the optimizer.
        model: torch NN.module instance.
        loss_fn: Loss function for the model.
    """

    def __init__(self, lr: float = 1e-3):
        """Initialize the MNISTClassifier.

        Args:
            lr (float): Learning rate for the optimizer.
        """
        super().__init__()
        self.save_hyperparameters()
        self.lr = lr

        self.model = nn.Sequential(
            nn.Flatten(),
            nn.Linear(28 * 28, 128),
            nn.ReLU(),
            nn.Linear(128, 64),
            nn.ReLU(),
            nn.Linear(64, 10),
        )
        self.loss_fn = nn.CrossEntropyLoss()

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        """Perform a forward pass through the model.

        Args:
            x (torch.Tensor): Input tensor.

        Returns:
            torch.Tensor: The model output.
        """
        return self.model(x)

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
        x, y = batch
        preds = self(x)
        loss = self.loss_fn(preds, y)
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
            torch.Tensor: The computed training loss.
        """
        x, y = batch
        preds = self(x)
        loss = self.loss_fn(preds, y)
        acc = (preds.argmax(dim=1) == y).float().mean()
        self.log('val_loss', loss, prog_bar=True)
        self.log('val_acc', acc, prog_bar=True)
        return loss

    def test_step(
        self,
        batch: tuple[dict[str, torch.Tensor], torch.Tensor],
        batch_idx: int,  # noqa: ARG002
    ) -> torch.Tensor:
        """Perform a test step.

        Args:
            batch (tuple[dict[str, torch.Tensor], torch.Tensor]):
                The input batch containing features and labels.
            batch_idx (int): The index of the batch.

        Returns:
            torch.Tensor: The computed training loss.
        """
        x, y = batch
        preds = self(x)
        loss = self.loss_fn(preds, y)
        acc = (preds.argmax(dim=1) == y).float().mean()
        self.log('test_loss', loss, prog_bar=True)
        self.log('test_acc', acc, prog_bar=True)
        return loss

    def configure_optimizers(self) -> torch.optim.Adam:
        """Configure the optimizer for the model.

        Returns:
            Adam: The Adam optimizer.
        """
        return torch.optim.Adam(self.parameters(), lr=self.lr)


def train_mnist(
    root_dir: Path,
    max_epochs: int = 10,
    batch_size: int = 16,
    accelerator: str = 'auto',
    devices: int | str | list[int] = 'auto',
    deterministic: bool = True,  # noqa: FBT001, FBT002
    random_seed: int = 42,
) -> None:
    """Train MNIST dataset with classification model.

    Args:
        root_dir (Path): Default path for logs and weights.
        max_epochs (int, optional):
            Stop training once this number of epochs is reached.
            Defaults to 10.
        batch_size (int, optional):
            Number of samples in a batch. Defaults to 16.
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

    # Data transformations and loading
    transform = transforms.Compose([transforms.ToTensor(), transforms.Normalize((0.5,), (0.5,))])
    mnist_dataset = datasets.MNIST(root_dir, train=True, download=True, transform=transform)

    train_size = int(0.8 * len(mnist_dataset))
    val_size = len(mnist_dataset) - train_size
    train_dataset, val_dataset = random_split(mnist_dataset, [train_size, val_size])

    train_loader = DataLoader(train_dataset, batch_size=batch_size, shuffle=True)
    val_loader = DataLoader(val_dataset, batch_size=batch_size)

    test_dataset = datasets.MNIST(root_dir, train=False, download=True, transform=transform)
    test_loader = DataLoader(test_dataset, batch_size=batch_size)

    # Model and Trainer setup
    model = MNISTClassifier()
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
