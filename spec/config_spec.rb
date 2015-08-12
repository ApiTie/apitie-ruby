require "spec_helper"

module ApiTie
  RSpec.describe Config do
    describe "validate!" do
      context "when no credentials are available" do
        it "validation should blow up" do
          expect { subject.validate! }
            .to raise_error ApiTie::MissingCredential
        end
      end

      context "when public key is missing" do
        before do
          subject.public_key = "somepublickey"
        end

        it "validation should blow up" do
          expect { subject.validate! }
            .to raise_error ApiTie::MissingCredential
        end
      end

      context "when private key is missing" do
        before do
          subject.private_key = "somesecureprivatekey"
        end

        it "validation should blow up" do
          expect { subject.validate! }
            .to raise_error ApiTie::MissingCredential
        end
      end

      context "when all credentials are available" do
        before do
          subject.public_key = "somepublikey"
          subject.private_key = "somesecureprivatekey"
        end

        it "validation should not blow up" do
          expect { subject.validate! }
            .to_not raise_error
        end
      end
    end
  end
end
