from django.db import models

class Usuario(models.Model):
    nombre = models.CharField(max_length=100)
    edad = models.IntegerField()
    correo = models.EmailField(unique=True)
    tarifa = models.DecimalField(max_digits=5, decimal_places=2)

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.nombre


class PerfilUsuario(models.Model):
    usuario = models.OneToOneField(Usuario, on_delete=models.CASCADE)
    avatar = models.CharField(max_length=255, blank=True)
    idioma = models.CharField(max_length=20, default="ES")
    activo = models.BooleanField(default=True)

    def __str__(self):
        return f"Perfil de {self.usuario.nombre}"


class Contenido(models.Model):
    class TipoContenido(models.TextChoices):
        PELICULA = 'PEL', 'Película'
        SERIE = 'SER', 'Serie'
        DOCUMENTAL = 'DOC', 'Documental'

    titulo = models.CharField(max_length=200)
    descripcion = models.TextField()
    duracion_min = models.IntegerField()
    fecha_estreno = models.DateField()
    tipo_cont = models.CharField(max_length=3, choices=TipoContenido.choices)
    director = models.CharField(max_length=100)
    activo = models.BooleanField(default=True)

    def __str__(self):
        return self.titulo


class Visualizacion(models.Model):
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    contenido = models.ForeignKey(Contenido, on_delete=models.CASCADE)
    minutos_visualizados = models.IntegerField()
    fecha_ultima_visualizacion = models.DateTimeField(auto_now=True)

    class Meta:
        constraints = [
            models.UniqueConstraint(
                fields=['usuario', 'contenido'],
                name='unique_visualizacion'
            )
        ]

    def __str__(self):
        return f"{self.usuario} - {self.contenido}"


class Reseña(models.Model):
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    contenido = models.ForeignKey(Contenido, on_delete=models.CASCADE)
    puntuacion = models.IntegerField()
    comentario = models.TextField(blank=True)
    fecha = models.DateField(auto_now_add=True)

    def __str__(self):
        return f"Reseña de {self.usuario} sobre {self.contenido}"


