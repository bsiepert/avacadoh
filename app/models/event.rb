class Event < ActiveRecord::Base
  has_many :players, through: :registrations
  has_many :registrations
  has_many :matches
  belongs_to :pg, class_name: 'Player'


  def generate_round
    # should complain if all matches are not reported
    @player_memo = initialize_player_memo
    point_groups = players.active.group_by {|pl| @player_memo[pl.id]['points']}.to_a.sort{|a,b| b[0]<=>a[0]}

    point_groups = point_groups.collect {|points, players|  players.collect {|player| player.id}}
    puts point_groups.inspect
    match_pairs = pair_groups(point_groups)

    puts match_pairs.inspect

    # might need to re-jigger the calcs on this
    if matches.length > 0
      last_round = matches.pluck(:round).sort.last
    else
      last_round = 0
    end

    new_round = last_round + 1

    match_pairs.each do |p1_id, p2_id|
      if p2_id == -1

        # will need to fix for D&C maybe leave partially submitted
        matches.create(p1_id: p1_id,
                     p2_id: -1, p1_control_points: 3,
                     p2_control_points: 0,
                     p1_army_points: 25,
                     p2_army_points: 0,
                     p1_list_played: 1,
                     p2_list_played: 1,
                     round: new_round,
                     winner_id: p1_id)
      else
        match = matches.build(p1_id: p1_id, p2_id: p2_id, round: new_round)
        match.save(validate: false)
      end
    end

  end

  def scoreboard
    player_memo = initialize_player_memo

    player_vitals = players.pluck(:id, :first_name, :last_name)
    sorted_players = player_vitals.sort_by do |player_id, fname, lname|
      sort_count = 0
      sort_count += player_memo[player_id]['points']*10000
      sort_count += player_memo[player_id]['sos']*1000
      sort_count += player_memo[player_id]['cps']*100
      sort_count
    end
    scoreboard = sorted_players.reverse.collect do |id, fname, lname|
      ["#{fname} #{lname}",
       player_memo[id]['points'],
       player_memo[id]['sos'],
       player_memo[id]['cps']
      ]
    end
    scoreboard
  end

  def pair_groups(group_pairs_master, pair_down=nil)
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
        return nil if had_bye?(pair_down)
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
      group_permutations = group_permutations.reject { |pr| paired_down?(pr.last) }
    end

    group_permutations.each do |group_permutation_master|
      group_list = group_permutation_master.dup
      match_pairs = []

      until group_list.length < 2
        pair = group_list.pop(2)
        match_pairs << [pair[0], pair[1]]
      end

      new_pair_down =  group_list.pop if group_list.length == 1

      if match_pairs.any? { |p1_id, p2_id| have_played?(p1_id, p2_id) }
        puts "skippin perm for played"
        next
      end

      remaining_pairs =
          pair_groups(remaining_groups, new_pair_down)
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
  private

  def initialize_player_memo
    # for each match in a round
    player_memo = {}
    players.each do |player|
      player_memo[player.id] = {}
      player_memo[player.id]['opponents'] = []
      player_memo[player.id]['paired_down'] = false
      player_memo[player.id]['points'] = 0
      player_memo[player.id]['bye'] = false
      player_memo[player.id]['cps'] = 0
      player_memo[player.id]['sos'] = 0
    end

    completed_matches = matches.all.reject {|m| m.winner.blank? || m.round.blank?}
    return player_memo if completed_matches.blank?

    rounds = completed_matches.group_by {|match| match.round}
    round_numbers = rounds.keys.sort

    round_numbers.each do |round_number|
      round_matches = rounds[round_number]
      round_matches.each do |round_match|
        p1_id = round_match.p1_id
        p2_id = round_match.p2_id
        player_memo[p1_id]['opponents'] << p2_id
        player_memo[p2_id]['opponents'] << p1_id

        player_memo[p1_id]['cps'] += round_match.p1_control_points
        player_memo[p2_id]['cps'] += round_match.p2_control_points

        player_memo[p1_id]['paired_down'] = true if player_memo[p1_id]['points'] <  player_memo[p2_id]['points']
        player_memo[p2_id]['paired_down'] = true if player_memo[p2_id]['points'] <  player_memo[p1_id]['points']

        player_memo[round_match.winner_id]['points'] += 1

        # this only works because the "bye" player is always p2
        player_memo[p1_id]['bye'] = true if (p2_id == -1)
      end
    end

    player_memo.each do |player_id, memo|
      memo['opponents'].each do |opponent_id|
        memo['sos'] += player_memo[opponent_id]['points']
      end
    end
    puts "player_memo:"
    puts player_memo
    player_memo
  end

  def have_played?(p1_id, p2_id)
    @player_memo[p1_id]['opponents'].include?(p2_id)
  end

  def paired_down?(player_id)
    @player_memo[player_id]['paired_down']
  end

  def had_bye?(player_id)
    @player_memo[player_id]['bye']
  end


end