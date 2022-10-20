# file: app.rb
require 'sinatra'
require "sinatra/reloader"
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
    all_albums = repo.all
    albums_titles = all_albums.map { |album| album.title }.join(', ')

    return albums_titles
  end

  get '/albums/:id' do
    album_id = params[:id]

    repo = AlbumRepository.new
    album = repo.find(album_id)

    return album.title
  end

  post '/albums' do
    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]
    repo = AlbumRepository.new
    repo.create(new_album)
  end
end
