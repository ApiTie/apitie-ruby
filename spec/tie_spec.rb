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
            users: [
              { id: 1, name: "Jon Snow", age: 24 },
              { id: 4, name: "Eddard Stark", age: 50 },
              { id: 8, name: "Arya Stark", age: 12 }
            ]
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

      context "containing records and associations" do
        before do
          stub_api("/characters").body \
            characters: [
              { id: 2, name: "Jon Snow", weapons: [7] },
              { id: 3, name: "Arya Stark", weapons: [1] }
            ],
            weapons: [
              { id: 7, name: "Longclaw" },
              { id: 1, name: "Needle" }
            ]
        end

        it "should parse them appropriately" do
          ApiTie.fetch_all("characters").tap do |records|
            expect_to_hit_api_with(get: "/characters")

            expect(records.characters.size).to eql 2
            expect(records.weapons.size).to eql 2

            expect(records.characters.first).to be_a(ApiTie::Record)
            expect(records.weapons.first).to be_a(ApiTie::Record)
          end
        end
      end
    end
  end
end
