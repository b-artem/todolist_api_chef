require 'support/api_schema_matcher'

module RequestSpecHelper
  def json
    JSON.parse(response.body)
  end

  shared_examples 'returns validation failure message - blank' do |attribute|
    it 'returns validation failure message' do
      expect(response.body)
      .to match(/#{attribute.to_s.capitalize} #{I18n.t('errors.messages.blank')}/)
    end
  end

  shared_examples 'matches response schema' do |schema|
    it 'matches response schema' do
      expect(response).to match_response_schema(schema)
    end
  end

  shared_examples 'returns response in JSON' do
    it 'returns response in JSON' do
      expect(response.content_type).to eq 'application/json'
    end
  end

  shared_examples 'returns status code 200' do
    it 'returns status code 200' do
      expect(response).to have_http_status 200
    end
  end

  shared_examples 'returns status code 201' do
    it 'returns status code 201' do
      expect(response).to have_http_status 201
    end
  end

  shared_examples 'returns status code 204' do
    it 'returns status code 204' do
      expect(response).to have_http_status 204
    end

    it 'returns empty body' do
      expect(response.body).to eq ''
    end
  end

  shared_examples 'returns status code 401' do
    it 'returns status code 401' do
      expect(response).to have_http_status 401
    end
  end

  shared_examples 'returns status code 403' do
    it 'returns status code 403' do
      expect(response).to have_http_status 403
    end
  end

  shared_examples 'returns status code 422' do
    it 'returns status code 422' do
      expect(response).to have_http_status 422
    end
  end
end
