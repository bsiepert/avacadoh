class Match < ActiveRecord::Base
  belongs_to :p1, class_name: Player, foreign_key:  'p1_id'
  belongs_to :p2, class_name: Player, foreign_key: 'p2_id'
  belongs_to :winner, class_name: Player, foreign_key: 'winner_id'

  validates :p1_army_points, :p2_army_points, :p1_control_points, :p2_control_points, :p1_list_played, :p2_list_played, :winner_id, presence: true
  # attr_accessible :round, :tournament_id, :sheet_id, :opponent_id, :list_played, :won, :control_points, :army_points

  def self.though_round(round)
    where('round < ? OR round = ?', round, round)
  end
  

  def self.generate_matches

    player_ids = Player.active.shuffle

    until player_ids.length < 2 do
      ids = player_ids.pop(2)
      match = Match.new(p1_id: ids[0], p2_id: ids[1])
      match.save(validate: false)
    end

    if player_ids.length == 1
      # fill out all match values
      last_player_id = player_ids.pop
      bye_match =  Match.create(p1_id: last_player_id,
                             p2_id: -1, p1_control_points: 3,
                             p2_control_points: 0,
                             p1_army_points: 25,
                             p2_army_points: 0,
                             p1_list_played: 1,
                             p2_list_played: 1,
                             winner_id: last_player_id)
      bye_match.save(validate: false)
    end
  end

  def self.generate_round
    @@player_memo = nil
    point_groups = Player.active.group_by {|pl| pl.points}.to_a.sort{|a,b| b[0]<=>a[0]}

    point_groups = point_groups.collect {|points, players|  players.collect {|player| player.id}}
    puts point_groups.inspect
    match_pairs = self.pair_groups(point_groups)

    puts match_pairs.inspect
    new_round = Match.pluck(:round).sort.last +1
    match_pairs.each do |p1_id, p2_id|
      if p2_id == -1
        Match.create(p1_id: p1_id,
                    p2_id: -1, p1_control_points: 3,
                    p2_control_points: 0,
                    p1_army_points: 25,
                    p2_army_points: 0,
                    p1_list_played: 1,
                    p2_list_played: 1,
                     round: new_round,
                    winner_id: p1_id)
      else
        match = Match.new(p1_id: p1_id, p2_id: p2_id, round: new_round)
        match.save(validate: false)
      end
    end

  end

  def self.pair_groups(group_pairs_master, pair_down=nil)
    paired_groups = nil
    group_pairs = group_pairs_master.dup # do we really need to dup?

    current_group = group_pairs.shift
    remaining_groups = group_pairs

    # end condition! this must always return something
    if current_group.nil? # because [].shift == nil
      # we've been passed and empty group
      if pair_down.nil?
        return []
      else
        return [[pair_down, -1]]
      end
    end
    current_group << pair_down if pair_down
    group_permutations = current_group.permutation.to_a.shuffle

    # we this group will need to pair down..
    # doing this first (and not with the "played?" culling means potentially looping through permutations we will never need)
    if current_group.length.odd?
      # remove permutations where the pair_down isn't elegible
      group_permutations =group_permutations.reject { |pr| pr.last == pair_down } if pair_down
      group_permutations = group_permutations.reject { |pr| Match.paired_down?(pr.last) }
    end

    group_permutations.each do |group_permutation_master|
      group_list = group_permutation_master.dup
      match_pairs = []

      until group_list.length < 2
        pair = group_list.pop(2)
        match_pairs << [pair[0], pair[1]]
      end

      new_pair_down =  group_list.pop if group_list.length == 1

      if match_pairs.any? { |p1_id, p2_id| Match.have_played?(p1_id, p2_id) }
        puts "skippin perm for played"
        next
      end

      remaining_pairs = Match.pair_groups(remaining_groups, new_pair_down)
      puts "remaining pairs: #{remaining_pairs.inspect}"
      if remaining_pairs.nil?
        next
      else
        paired_groups = match_pairs + remaining_pairs
        break
      end

    end

    return paired_groups
  end

  def self.initialize_player_memo
    # for each match in a round
    player_memo = {}
    matches = Match.all.reject {|m| m.winner.blank? || m.round.blank?}
    return if matches.blank?
    rounds = matches.group_by {|match| match.round}
    round_numbers = rounds.keys.sort
    rounds[1].each do |r1_match|
      player_memo[r1_match.p1_id] = {}
      player_memo[r1_match.p1_id]['opponents'] = []
      player_memo[r1_match.p1_id]['paired_down'] = false
      player_memo[r1_match.p1_id]['points'] = 0
      player_memo[r1_match.p2_id] = {}
      player_memo[r1_match.p2_id]['opponents'] = []
      player_memo[r1_match.p2_id]['paired_down'] = false
      player_memo[r1_match.p2_id]['points'] = 0
    end
    round_numbers.each do |round_number|
      round_matches = rounds[round_number]
      round_matches.each do |round_match|
        p1_id = round_match.p1_id
        p2_id = round_match.p2_id
        player_memo[p1_id]['opponents'] << p2_id
        player_memo[p2_id]['opponents'] << p1_id

        player_memo[p1_id]['paired_down'] = true if player_memo[p1_id]['points'] <  player_memo[p2_id]['points']
        player_memo[p2_id]['paired_down'] = true if player_memo[p2_id]['points'] <  player_memo[p1_id]['points']

        player_memo[round_match.winner_id]['points'] += 1
      end
    end
    puts "player_memo:"
    puts player_memo
    player_memo
  end

  def self.have_played?(p1_id, p2_id)
    @@player_memo ||=  initialize_player_memo
    @@player_memo[p1_id]['opponents'].include?(p2_id)
  end

  def self.paired_down?(player_id)
    @@player_memo ||=  initialize_player_memo
    @@player_memo[player_id]['paired_down']
  end

end