"""
Configuracion WSGI para el proyecto config.

Expone el callable WSGI como una variable de modulo llamada ``application``.

Para mas informacion sobre este archivo, consulta:
https://docs.djangoproject.com/en/6.0/howto/deployment/wsgi/
"""

import os

from django.core.wsgi import get_wsgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')

application = get_wsgi_application()
