# file: app.rb
require 'sinatra'
require 'sinatra/reloader'
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/albums' do
    repo = AlbumRepository.new
    @albums = repo.all

    return erb(:albums)
  end

  get '/albums/:id' do
    album_id = params[:id]

    album_repo = AlbumRepository.new
    artist_repo = ArtistRepository.new

    album = album_repo.find(album_id)

    artist = artist_repo.find(album.artist_id)

    @album_title = album.title
    @album_release_date = album.release_year
    @album_artist = artist.name

    return erb(:album)
  end

  post '/albums' do
    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]
    repo = AlbumRepository.new
    repo.create(new_album)
  end

  get '/artists' do
    repo = ArtistRepository.new
    all_artists = repo.all

    artists_names = all_artists.map { |artist| artist.name }.join(', ')
    return artists_names
  end

  post '/artists' do
    repo = ArtistRepository.new

    new_artist = Artist.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]

    repo.create(new_artist)
  end
end
