import os

ALLOWED_HOSTS = ['*']

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': os.environ.get('POSTGRES_DB'),
        'USER': os.environ.get('POSTGRES_USER'),
        'PASSWORD': os.environ.get('POSTGRES_PASSWORD'),
        'HOST': 'postgres',
        'PORT': '5432',
    }
}

CELERY_RESULT_BACKEND = 'redis://redis:6379/0'
BROKER_URL = 'amqp://{}:{}@rabbitmq:5672/{}'.format(
    os.environ.get('RABBITMQ_DEFAULT_USER'),
    os.environ.get('RABBITMQ_DEFAULT_PASS'),
    os.environ.get('RABBITMQ_DEFAULT_VHOST'),
)
