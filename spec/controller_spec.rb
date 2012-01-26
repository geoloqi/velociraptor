require_relative './helper.rb'

describe Controller do
  before do
    @app = Controller
  end
  
  describe 'the index' do
    it 'should say hello' do
      get '/'
      last_response.status.must_equal 200
      last_response.body.must_equal 'hello'
    end
  end
end