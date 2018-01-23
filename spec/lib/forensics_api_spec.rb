# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/forensics_api'

RSpec.describe ForensicsAPI do
  subject { described_class.new('foo@bar.com') }

  describe '#retrieve_directions' do
    let(:directions) do
      %w[
        forward right forward
        forward forward left
        forward forward left
        right forward right
        forward forward right
        forward forward left
      ]
    end
    let(:url) { 'http://which-technical-exercise.herokuapp.com/api/foo@bar.com/directions' }
    let(:response_body) { { directions: directions } }

    context 'when the response is successful' do
      before do
        stub_request(:get, url).to_return(status: 200, body: response_body.to_json)
      end

      it 'outputs the directions from the api endpoint' do
        expect(subject.retrieve_directions).to eq(directions)
      end
    end

    context 'when the response is not successful' do
      before do
        stub_request(:get, url).to_return(status: 500)
      end

      it 'outputs an error message' do
        expect { subject.retrieve_directions }.to raise_error(described_class::ServerError, /The server could not be reached at this moment please try again soon/)
      end
    end
  end

  describe '#check_location' do
    let(:url) { 'http://which-technical-exercise.herokuapp.com/api/foo@bar.com/location' }

    context 'when the server responds succsefully' do
      context 'when the location is correct' do
        let(:message) do
          <<~MESSAGE
            "Congratulations! The search party successfully recovered the missing kittens. Please zip up your code and send it to richard.hart@which.co.uk."
          MESSAGE
        end
        let(:response_body) { { message: message } }

        before do
          stub_request(:get, "#{url}/1/5").to_return(status: 200, body: response_body.to_json)
        end

        it 'outputs a success message' do
          expect(subject.check_location(x: 1, y: 5)).to eq(message + ' For location X: 1, Y: 5')
        end
      end

      context 'when the location is not correct' do
        let(:message) do
          <<~MESSAGE
            'Unfortunately, the search party failed to recover the missing kittens. You have 3 attempts remaining.'
          MESSAGE
        end
        let(:response_body) { { message: message } }

        before do
          stub_request(:get, "#{url}/1/-5").to_return(status: 200, body: response_body.to_json)
        end

        it 'outputs an unsucessfull message' do
          expect(subject.check_location(x: 1, y: -5)).to eq(message + ' For location X: 1, Y: -5')
        end
      end
    end

    context 'when the server responds unsucessfully' do
      before do
        stub_request(:get, "#{url}/1/-5").to_return(status: 500)
      end

      it 'outputs an error message' do
        expect { subject.check_location(x: 1, y: -5) }.to raise_error(described_class::ServerError, /The server could not be reached at this moment please try again soon/)
      end
    end
  end
end
