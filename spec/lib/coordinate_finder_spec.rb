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
    it 'outputs the coordinates of the kittens' do
      expect(subject.call).to eq(x: 5, y: 2)
    end
  end
end
