from django.urls import path, include
from .views import UsuarioListaCrear, UsuarioDetalle, ContenidoListaCrear, ContenidoDetalle
from rest_framework.routers import DefaultRouter
from .views import UsuarioViewSet, ContenidoViewSet

router = DefaultRouter()
router.register(r'usuarios', UsuarioViewSet)
router.register(r'contenidos', ContenidoViewSet)

urlpatterns = [
    path('usuarios/', UsuarioListaCrear.as_view()),
    path('usuarios/<int:pk>/', UsuarioDetalle.as_view()),
    path('contenido/', ContenidoListaCrear.as_view()),
    path('contenido/<int:pk>/', ContenidoDetalle.as_view()),   
    path('api/', include(router.urls)),
]
