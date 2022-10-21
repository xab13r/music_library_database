require 'spec_helper'
require 'rack/test'
require_relative '../../app'

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  describe 'GET /albums' do
    it 'returns all the albums in the database' do
      response = get('/albums')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Albums</h1>')
      expect(response.body).to include('<a href="/albums/2">Surfer Rosa, 1988</a>')
      expect(response.body).to include('<a href="/albums/3">Waterloo, 1974</a>')
    end
  end

  describe 'GET /albums/:id' do
    it 'returns the title of the album given the id' do
      response = get('/albums/2')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Surfer Rosa</h1>')
      expect(response.body).to include('Release year: 1988')
      expect(response.body).to include('Artist: Pixies')
    end
  end

  describe 'GET /artists/:id' do
    it 'returns a page with the details for an artist given teh id' do
      response = get('/artists/1')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Pixies</h1>')
      expect(response.body).to include('<p>Genre: Rock</p>')
    end
  end

  describe 'GET /artists' do
    it 'returns all the artists in the databse' do
      response = get('/artists')

      expect(response.body).to include('<a href="/artists/1">Pixies, Rock</a>')
      expect(response.body).to include('<a href="/artists/2">ABBA, Pop</a>')
      expect(response.body).to include('<a href="/artists/3">Taylor Swift, Pop</a>')
    end
  end

  describe 'GET /albums/new' do
    it ' returns the form to add a new album' do
      response = get('/albums/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('<form action="/albums" method="POST">')
      expect(response.body).to include('<input type="text" name="title">')
      expect(response.body).to include('<input type="text" name="release_year">')
      expect(response.body).to include('<input type="text" name="artist_id">')
    end
  end

  describe 'GET /artists/new' do
    it ' returns the form to add a new album' do
      response = get('/artists/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('<form action="/artists" method="POST">')
      expect(response.body).to include('<input type="text" name="name">')
      expect(response.body).to include('<input type="text" name="genre">')
    end
  end

  describe 'POST /albums' do
    it 'should validate album parameters' do
      response = post(
        '/albums',
        invalid_album_title: 'OK Computer',
        another_invalid_thing: 123
      )

      expect(response.status).to eq(400)
    end

    it 'adds a new albums to the database' do
      post_response = post(
        '/albums',
        title: 'Voyage',
        release_year: 2022,
        artist_id: 2
      )
      get_response = get('/albums')

      expect(post_response.status).to eq 200
      expect(get_response.body).to include('Voyage')
    end
  end

  describe 'POST /artists' do
    it "should validate artists parameters" do
      response = post(
        '/artists',
        invalid_artist_name: 'Taylor Swift',
        invalid_second_artist: 'Pixies'
      )
      
      expect(response.status).to eq(400)
    end
    
    it 'adds a new artist to the database' do
      post_response = post(
        '/artists',
        name: 'Wild Nothing',
        genre: 'Indie'
      )

      expect(post_response.status).to eq(200)
      expect(post_response.body).to include('<h1>Artist Created!</h1>')
    end
  end
end
