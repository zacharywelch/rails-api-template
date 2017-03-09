require 'rails_helper'

describe 'Swagger' do

  let(:json) { JSON.parse(response.body) }
  let(:path) { '/swagger' }
  let(:swagger) { JSON.parse(File.read('public/swagger.json')) }

  describe 'GET /swagger' do
    before { get path }

    it { expect(json).to eq swagger }
  end
end
