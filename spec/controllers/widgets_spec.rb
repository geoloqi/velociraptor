require_relative '../helper.rb'

describe Widgets do
  before do
    @app = Widgets
  end

  describe 'collection' do
    it 'returns 200' do
      get '/'
      last_response.status.must_equal 200
      last_response.body.must_equal 'This is the /widgets/? route.'
    end
  end

end