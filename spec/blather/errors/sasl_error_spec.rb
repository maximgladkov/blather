require 'spec_helper'

def sasl_error_node(err_name = 'aborted')
  node = Blather::XMPPNode.new 'failure'
  node.namespace = Blather::SASLError::SASL_ERR_NS

  node << Blather::XMPPNode.new(err_name, node.document)
  node
end

describe Blather::SASLError do
  it 'can import a node' do
    expect(Blather::SASLError).to respond_to :import
    e = Blather::SASLError.import sasl_error_node
    expect(e).to be_kind_of Blather::SASLError
  end

  describe 'each XMPP SASL error type' do
    %w[ aborted
        incorrect-encoding
        invalid-authzid
        invalid-mechanism
        mechanism-too-weak
        not-authorized
        temporary-auth-failure
    ].each do |error_type|
      it "handles the name for #{error_type}" do
        e = Blather::SASLError.import sasl_error_node(error_type)
        expect(e.name).to eq(error_type.gsub('-','_').to_sym)
      end
    end
  end
end
