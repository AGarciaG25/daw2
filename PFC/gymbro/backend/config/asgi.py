"""
Configuracion ASGI para el proyecto config.

Expone el callable ASGI como una variable de modulo llamada ``application``.

Para mas informacion sobre este archivo, consulta:
https://docs.djangoproject.com/en/6.0/howto/deployment/asgi/
"""

import os

from django.core.asgi import get_asgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')

application = get_asgi_application()
