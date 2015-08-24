RSpec.describe ApiTie do
  describe "fetching records" do
    before do
      ApiTie.config do |c|
        c.public_key = "dontcare"
        c.private_key = "dontcareeither"
      end
    end

    describe "for an existing collection" do
      context "containing records" do
        before do
          stub_api("/users").body \
            data: [
              { type: "users", id: 1, name: "Jon Snow", age: 24 },
              { type: "users", id: 4, name: "Eddard Stark", age: 50 },
              { type: "users", id: 8, name: "Arya Stark", age: 12 }
            ],
            included: []
        end

        it "should parse them appropriately" do
          ApiTie.fetch_all("users").tap do |records|
            expect_to_hit_api_with(get: "/users")

            expect(records).to_not be_empty
            expect(records.users.size).to eql 3

            expect(records).to be_a(ApiTie::Body)
            expect(records.users.first).to be_a(ApiTie::Record)
          end
        end
      end
    end
  end
end
