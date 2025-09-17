from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    DATABASE_URL: str
    DB_PORT: int
    DB_HOST: str
    SECRET_KEY: str
    APP_PORT: int
    REDIS_PORT: int
    REDIS_HOST: str
    REDIS_URL: str
    HOST: str
    DEBUG: bool = False

    class Config:
        env_file = '.env'


settings = Settings()
