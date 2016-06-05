describe("comments", function()
	setup(function()
		TOML = require "toml"
	end)

	it("everywhere", function()
		local obj = TOML.parse[=[
# Top comment.
  # Top comment.
# Top comment.

# [no-extraneous-groups-please]

[group] # Comment
answer = 42 # Comment
# no-extraneous-keys-please = 999
# Inbetween comment.
more = [ # Comment
  # What about multiple # comments?
  # Can you handle it?
  #
          # Evil.
# Evil.
  42, 42, # Comments within arrays are fun.
  # What about multiple # comments?
  # Can you handle it?
  #
          # Evil.
# Evil.
# ] Did I fool you?
] # Hopefully not.]=]
		local sol = {
			group = {
				answer = 42,
				more = {42, 42},
			}
		}
		assert.same(sol, obj)
	end)
end)
