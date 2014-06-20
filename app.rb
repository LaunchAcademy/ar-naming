require 'sinatra'
require 'sinatra/activerecord'

enable :sessions

configure do
  set :views, 'app/views'
end

Dir[File.join(File.dirname(__FILE__), 'app', '**', '*.rb')].each do |file|
  require file
end

get '/' do
  erb :index
end

get '/challenge' do
  session[:right] ||= 0
  session[:wrong] ||= 0

  @challenge = Challenge.all.sample
  @question = Challenge.questions.sample.to_s

  erb :challenge
end

post '/challenge' do
  @challenge = Challenge.find(params[:challenge_id])
  @question = params[:question]
  @correct_answer = @challenge.try(@question)

  @result = @challenge.correct?(params[:question], params[:submission])
  if @result
    session[:right] += 1
  else
    session[:wrong] += 1
  end

  erb :result
end
