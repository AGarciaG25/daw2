from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import status, viewsets, serializers
from rest_framework.decorators import action
from rest_framework.filters import OrderingFilter, SearchFilter
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response

from .filters import CursoFilter
from .models import (
    Categoria,
    Curso,
    Estudiante,
    Etiqueta,
    Inscripcion,
    Instructor,
    Valoracion,
)
from .serializers import (
    CategoriaSerializer,
    EtiquetaSerializer,
    InstructorSerializer,
    EstudianteSerializer,
    CursoSerializer,
    CursoDetalleSerializer,
    InscripcionSerializer,
    ValoracionSerializer,
)


class ValoracionViewSet(viewsets.ModelViewSet):
    queryset = Valoracion.objects.all()
    serializer_class = ValoracionSerializer

    def get_permissions(self):
        if self.action in ["list", "retrieve"]:
            return [AllowAny()]
        return [IsAuthenticated()]

    def get_queryset(self):
        qs = super().get_queryset()
        curso_id = self.request.query_params.get("curso")
        if curso_id:
            qs = qs.filter(curso_id=curso_id)
        return qs



class CategoriaViewSet(viewsets.ModelViewSet):
    queryset = Categoria.objects.all()
    serializer_class = CategoriaSerializer

    def get_permissions(self):
        if self.action in ["list", "retrieve"]:
            return [AllowAny()]
        return [IsAuthenticated()]


class EtiquetaViewSet(viewsets.ModelViewSet):
    queryset = Etiqueta.objects.all()
    serializer_class = EtiquetaSerializer

    def get_permissions(self):
        if self.action in ["list", "retrieve"]:
            return [AllowAny()]
        return [IsAuthenticated()]


class InstructorViewSet(viewsets.ModelViewSet):
    queryset = Instructor.objects.all()
    serializer_class = InstructorSerializer

    def get_permissions(self):
        if self.action in ["list", "retrieve"]:
            return [AllowAny()]
        return [IsAuthenticated()]


class EstudianteViewSet(viewsets.ModelViewSet):
    queryset = Estudiante.objects.select_related("usuario").all()
    serializer_class = EstudianteSerializer
    permission_classes = [IsAuthenticated]


class CursoViewSet(viewsets.ModelViewSet):
    queryset = (
        Curso.objects.all()
        .select_related("categoria", "instructor")
        .prefetch_related("etiquetas")
    )

    @action(detail=True, methods=["post"], permission_classes=[IsAuthenticated])
    def cambiar_estado(self, request, pk=None):
        curso = self.get_object()
        curso.activo = not curso.activo
        curso.save()
        return Response(
            {"id": curso.id, "activo": curso.activo},
            status=status.HTTP_200_OK
        )

    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_class = CursoFilter
    search_fields = ["titulo", "descripcion"]
    ordering_fields = ["precio", "fecha_inicio", "titulo", "created_at"]
    ordering = ["fecha_inicio"]

    def get_permissions(self):
        if self.action in ["list", "retrieve"]:
            return [AllowAny()]
        return [IsAuthenticated()]

    def get_serializer_class(self):
        if self.action == "repetir_curso":
            return CursoDetalleSerializer
        return CursoSerializer

    @action(detail=False, methods=["get"], permission_classes=[IsAuthenticated])
    def destacados(self, request):
        cursos = Curso.objects.filter(activo=True)
        serializer = self.get_serializer(cursos, many=True)
        return Response(serializer.data)

    @action(detail=True, methods=["post"], permission_classes=[IsAuthenticated])
    def inscribirse(self, request, pk=None):
        curso = self.get_object()

        try:
            estudiante = request.user.estudiante
        except Estudiante.DoesNotExist:
            return Response(
                {"error": "El usuario autenticado no tiene perfil de estudiante"},
                status=status.HTTP_400_BAD_REQUEST
            )

        inscripcion, creada = Inscripcion.objects.get_or_create(
            curso=curso,
            estudiante=estudiante
        )

        if not creada:
            return Response(
                {"error": "El estudiante ya está inscrito"},
                status=status.HTTP_409_CONFLICT
            )

        return Response(
            {"mensaje": "Inscripción realizada correctamente"},
            status=status.HTTP_201_CREATED
        )


class InscripcionViewSet(viewsets.ModelViewSet):
    queryset = (
        Inscripcion.objects.all()
        .select_related("estudiante", "curso", "estudiante__usuario")
    )
    serializer_class = InscripcionSerializer
    permission_classes = [IsAuthenticated]
