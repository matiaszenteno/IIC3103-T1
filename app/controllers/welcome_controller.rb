class WelcomeController < ApplicationController
  def index
      bcs_episodes_response = RestClient.get "https://tarea-1-breaking-bad.herokuapp.com/api/episodes?series=Better+Call+Saul"
      bcs_episodes = JSON.parse bcs_episodes_response
      @bcs_seasons = Array.new(bcs_episodes[-1]['season'].to_i) {|i| i+1}

      bb_episodes_response = RestClient.get "https://tarea-1-breaking-bad.herokuapp.com/api/episodes?series=Breaking+Bad"
      bb_episodes = JSON.parse bb_episodes_response
      @bb_seasons = Array.new(bb_episodes[-1]['season'].to_i) {|i| i+1}

  end

  def search
      search_term = params['search'].capitalize
      response = RestClient.get "https://tarea-1-breaking-bad.herokuapp.com/api/characters?name=#{search_term}"
      @characters = JSON.parse response
      render :search
  end

  def season
    show = params['show']
    @season_id = params['season_id']

    if show == 'breakingbad'
      @show_title = 'Breaking Bad'
      episodes_response = RestClient.get "https://tarea-1-breaking-bad.herokuapp.com/api/episodes?series=Breaking+Bad"
    end

    if show == 'bettercallsaul'
      @show_title = 'Better Call Saul'
      episodes_response = RestClient.get "https://tarea-1-breaking-bad.herokuapp.com/api/episodes?series=Better+Call+Saul"
    end

    episodes = JSON.parse episodes_response
    @episodes_filtered = episodes.select { |episode| episode['season'] == @season_id }
    render :episodes
  end

  def episode
    @episode_id = params['episode_id']
    episode_response = RestClient.get "https://tarea-1-breaking-bad.herokuapp.com/api/episodes/#{@episode_id}"
    @episode = (JSON.parse episode_response)[0]

    all_characters_response = RestClient.get "https://tarea-1-breaking-bad.herokuapp.com/api/characters"
    all_characters = JSON.parse all_characters_response
    @characters = all_characters.select { |character| character['name'].in?(@episode['characters']) }

    render :episode
  end

  def character
    search_term = params['search'].capitalize
    response = RestClient.get "https://tarea-1-breaking-bad.herokuapp.com/api/characters?name=#{search_term}"
    @characters = JSON.parse response
    render :search
  end

  def char
    @character_id = params['character_id']
    character_response = RestClient.get "https://tarea-1-breaking-bad.herokuapp.com/api/characters/#{@character_id}"
    @character = (JSON.parse character_response)[0]
    
    bcs_episodes_response = RestClient.get "https://tarea-1-breaking-bad.herokuapp.com/api/episodes?series=Better+Call+Saul"
    bcs_episodes = JSON.parse bcs_episodes_response
    @bcs_episodes = bcs_episodes.select { |episode| @character['name'].in?(episode['characters']) }

    bb_episodes_response = RestClient.get "https://tarea-1-breaking-bad.herokuapp.com/api/episodes?series=Breaking+Bad"
    bb_episodes = JSON.parse bb_episodes_response
    @bb_episodes = bb_episodes.select { |episode| @character['name'].in?(episode['characters']) }

    render :character
  end

end
