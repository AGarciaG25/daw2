from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import Usuario, Contenido
from .serializers import UsuarioSerializer, ContenidoSerializer
from rest_framework.viewsets import ModelViewSet


class UsuarioViewSet(ModelViewSet):
    queryset = Usuario.objects.all()
    serializer_class = UsuarioSerializer

class ContenidoViewSet(ModelViewSet):
    queryset = Contenido.objects.all()
    serializer_class = ContenidoSerializer

class UsuarioListaCrear(APIView):

    def get(self, request):
        usuarios = Usuario.objects.all()
        serializer = UsuarioSerializer(usuarios, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def post(self, request):
        serializer = UsuarioSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(
                serializer.data,
                status=status.HTTP_201_CREATED
            )
        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )

class UsuarioDetalle(APIView):

    def get(self, request, pk):
        try:
            usuario = Usuario.objects.get(pk=pk)
        except Usuario.DoesNotExist:
            return Response(
                {"error": "Usuario no encontrado"},
                status=status.HTTP_404_NOT_FOUND
            )

        serializer = UsuarioSerializer(usuario)
        return Response(serializer.data, status=status.HTTP_200_OK)

class ContenidoListaCrear(APIView):

    def get(self, request):
        contenidos = Contenido.objects.all()
        serializer = ContenidoSerializer(contenidos, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def post(self, request):
        serializer = ContenidoSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(
                serializer.data,
                status=status.HTTP_201_CREATED
            )
        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )

class ContenidoDetalle(APIView):

    def get(self, request, pk):
        try:
            contenido = Contenido.objects.get(pk=pk)
        except Contenido.DoesNotExist:
            return Response(
                {"error": "Contenido no encontrado"},
                status=status.HTTP_404_NOT_FOUND
            )

        serializer = ContenidoSerializer(contenido)
        return Response(serializer.data, status=status.HTTP_200_OK)
