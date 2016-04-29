require 'spec_helper'

RSpec.describe SupportBee::Errors do
  it { expect(SupportBee::Errors::InvalidTag).to be < ArgumentError }
end
