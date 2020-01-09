class StatsController < ApplicationController
  def show
    @url                 = request.url
    @dojo_count          = Dojo.active_dojos_count
    @regions_and_dojos   = Dojo.group_by_region_on_active

    # TODO: 次の静的なDojoの開催数もデータベース上で集計できるようにする
    # https://github.com/coderdojo-japan/coderdojo.jp/issues/190
    @sum_of_events       = EventHistory.count
    @sum_of_dojos        = DojoEventService.count('DISTINCT dojo_id')
    @sum_of_participants = EventHistory.sum(:participants)

    # 2012年1月1日〜2019年12月31日までの集計結果
    period        = Time.zone.local(2012).beginning_of_year..Time.zone.local(2019).end_of_year
    statistics    = Stat.new(period)
    @dojos        = statistics.annual_sum_total_of_aggregatable_dojo
    @events       = statistics.annual_count_of_event_histories
    @participants = statistics.annual_sum_of_participants

    @high_charts_globals          = HighChartsBuilder.global_options
    @annual_dojos_chart           = statistics.annual_dojos_chart
    @annual_event_histories_chart = statistics.annual_event_histories_chart
    @annual_participants_chart    = statistics.annual_participants_chart
  end
end
