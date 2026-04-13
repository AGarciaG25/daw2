from rest_framework import serializers
from .models import Usuario
from .models import Contenido

class UsuarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = Usuario
        fields = ['id', 'nombre', 'edad', 'correo', 'tarifa']
        extra_kwargs = {
            'id': {'read_only': True}
        }

    def validate_tarifa(self, value):
        if value < 0:
            raise serializers.ValidationError("El tarifa no puede ser negativo")
        return value

class ContenidoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Contenido
        fields = [
            'id',
            'titulo',
            'descripcion',
            'duracion_min',
            'fecha_estreno',
            'tipo_cont',
            'director',
            'activo'
        ]
        extra_kwargs = {
            'id': {'read_only': True}
        }