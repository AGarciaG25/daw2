from django.contrib import admin

# Register your models here.
from django.contrib import admin
from .models import Usuario, PerfilUsuario, Contenido, Visualizacion, Reseña

# --- Admin para Usuario ---
@admin.register(Usuario)
class UsuarioAdmin(admin.ModelAdmin):
    list_display = ('nombre', 'edad', 'correo', 'tarifa', 'created_at')
    search_fields = ('nombre', 'correo')
    list_filter = ('edad',)
    ordering = ('nombre',)


# --- Admin para PerfilUsuario ---
@admin.register(PerfilUsuario)
class PerfilUsuarioAdmin(admin.ModelAdmin):
    list_display = ('usuario', 'avatar', 'idioma', 'activo')
    search_fields = ('usuario__nombre', 'idioma')
    list_filter = ('activo', 'idioma')


# --- Admin para Contenido ---
@admin.register(Contenido)
class ContenidoAdmin(admin.ModelAdmin):
    list_display = ('titulo', 'tipo_cont', 'director', 'fecha_estreno', 'activo')
    search_fields = ('titulo', 'director')
    list_filter = ('tipo_cont', 'activo', 'fecha_estreno')
    ordering = ('titulo',)


# --- Admin para Visualizacion ---
@admin.register(Visualizacion)
class VisualizacionAdmin(admin.ModelAdmin):
    list_display = ('usuario', 'contenido', 'minutos_visualizados', 'fecha_ultima_visualizacion')
    search_fields = ('usuario__nombre', 'contenido__titulo')
    list_filter = ('fecha_ultima_visualizacion',)


# --- Admin para Reseña ---
@admin.register(Reseña)
class ReseñaAdmin(admin.ModelAdmin):
    list_display = ('usuario', 'contenido', 'puntuacion', 'fecha')
    search_fields = ('usuario__nombre', 'contenido__titulo', 'comentario')
    list_filter = ('puntuacion', 'fecha')
    ordering = ('-fecha',)
