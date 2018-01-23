# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/coordinate_finder.rb'

RSpec.describe CoordinateFinder do
  let(:directions) do
    %w[
      forward right forward forward
      forward left forward forward left
      right forward right forward forward
      right forward forward left
    ]
  end
  subject { described_class.new(directions) }

  describe '#call' do
    context 'when correct directions are provided' do
      it 'outputs the coordinates of the kittens' do
        expect(subject.call).to eq(x: 5, y: 2)
      end
    end

    context 'when incorrect directions are provided' do
      let(:directions) { ['forwar'] }

      it 'raises an error' do
        expect { subject.call }.to raise_error(described_class::IncorrectDirection, /Incorrect direction provided/)
      end
    end
  end
end
