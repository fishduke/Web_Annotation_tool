from django.contrib import admin
#from django_gunicorn.album.models import Album,Song.
from .models import Album, Song
# Register your models here.
admin.site.register(Album)
admin.site.register(Song)
