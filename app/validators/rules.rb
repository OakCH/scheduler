class Rules < ActiveModel::Validator

    def validate(record)
        unless is_week?(record)
            record.errors[:end_at] << 'Treat yourself. Take more vacation days'
        end

        unless up_to_4_segs?(record)
            record.errors[:segs] << 'You have more than 4 segments. Please add vacation days to an existing segment'
        end

        unless less_than_allowed?(record)
            record.errors[:allowed] << 'You have selected more vacation days than you have accrued'
        end
    end

    # at least one week
    def is_week?(record)
        return calculate_length(record) >= 7
    end

    # not more than 4 segments
    def up_to_4_segs?(record)
        return Events.find_by_nurse_id(record.nurse_id).count <= 3 # the current one is #4
    end

     # no more weeks than allowed
     def less_than_allowed?(record)
         num_days_total = record.nurse.num_weeks_off * 7
         num_days_taken = 0
         Events.find_by_nurse_id(record.nurse_id).each do |event|
             num_days_taken += calculate_length(event)
         end
         num_days_taken += calculate_length(record)
         return num_days_taken < num_days_total
     end

     def calculate_length (event)
        start_at = DateTime.parse(event.start_at)
        end_at = DateTime.parse(event.end_at)
        return days_total = end_at.to_time - start_at.to_time
    end
end
