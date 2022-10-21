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

  get '/albums/new' do
    return erb(:new_album)
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

  get '/artists/new' do
    return erb(:new_artist)
  end

  get '/artists/:id' do
    artist_id = params[:id]
    repo = ArtistRepository.new

    @artist = repo.find(artist_id)
    return erb(:artist)
  end

  get '/artists' do
    repo = ArtistRepository.new
    @artists = repo.all
    return erb(:artists)
  end

  post '/albums' do
    if albums_invalid_request_parameters?
      status 400
      return ''
    end

    repo = AlbumRepository.new
    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]

    repo.create(new_album)
    return erb(:album_created)
  end

  post '/artists' do
    if artists_invalid_request_parameters?
      status 400
      return ''
    end

    repo = ArtistRepository.new

    new_artist = Artist.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]

    repo.create(new_artist)
    return erb(:artist_created)
  end

  def albums_invalid_request_parameters?
    params[:title].nil? || params[:release_year].nil? || params[:artist_id].nil?
  end

  def artists_invalid_request_parameters?
    params[:name].nil? || params[:genre].nil?
  end
end
