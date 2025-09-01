"""Application settings using Pydantic Settings."""

from functools import lru_cache

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Application settings loaded from environment variables and .env file."""

    model_config = SettingsConfigDict(
        env_file='.env',
        env_file_encoding='utf-8',
        case_sensitive=False,
        extra='ignore',
    )

    # API Settings
    api_host: str = Field(default='0.0.0.0', description='API host')  # noqa: S104
    api_port: int = Field(default=5000, description='API port')
    debug: bool = Field(default=False, description='Debug mode')
    log_level: str = Field(default='INFO', description='Log level')

    # CORS Settings
    cors_origins: list[str] = Field(
        default=['http://localhost:3000', 'http://localhost:8080'],
        description='Allowed CORS origins',
    )

    # Server Settings
    max_workers: int = Field(default=1, description='Maximum number of workers')

    # Model Settings
    model_name: str = Field(default='default', description='Model name to use')
    model_path: str = Field(default='models/', description='Path to model files')

    # Data Processing Settings
    max_batch_size: int = Field(default=32, description='Maximum batch size for predictions')
    timeout_seconds: float = Field(default=30.0, description='Request timeout in seconds')


@lru_cache
def get_settings() -> Settings:
    """Get cached application settings.

    Returns:
        Settings: Application settings instance.
    """
    return Settings()
