require 'rspec'

def leaf_plucker(tree)
  shredder = []
  leaves = []
  branches_to_check = [tree]

  until branches_to_check.empty?
    branch = branches_to_check.shift
    branch.each do |checking_branch, brancher|
      case brancher.class.to_s
      when 'Hash' then branches_to_check << brancher
      when 'Fixnum' then leaves << brancher
      else shredder << [checking_branch, brancher]
      end
    end
  end

  leaves.sort
end


RSpec.describe do
  it 'plucks the leaves' do
    example_tree = { a: 1, b: 2, c: { d: 3, e: { f: 4 }, g: 5, h: { i: 6, j: { k: 7 } } }, l: 8 }
    expect(leaf_plucker(example_tree).sort).to eql (1..8).to_a
  end
end
