# include: "//app-event-ga360/*.view"

explore: ga_sessions_config {
  extends: [ga_sessions_template]
  extension: required

#  always_filter: {
#     filters: {
#       field: ga_sessions.date_date
#       value: "7 days ago for 7 days"
#     }
#   }

# Acquisition Dashboard -- Aggregate Awareness Tables (https://docs.looker.com/reference/explore-params/aggregate_table)
  aggregate_table: rollup__date_period__0 {
    query: {
      dimensions: [date_period]
      measures: [returning_visitors, session_count, totals.bounce_rate, totals.timeonsite_average_per_session, totals.transaction_conversion_rate, unique_visitors]
    }

    materialization: {
      persist_for: "24 hours"
    }
  }

  aggregate_table: rollup__date_period__1 {
    query: {
      dimensions: [date_period]
      measures: [returning_visitors, session_count, totals.bounce_rate, totals.newVisits_total, totals.timeonsite_average_per_session, totals.transaction_conversion_rate, unique_visitors]
    }

    materialization: {
      persist_for: "24 hours"
    }
  }

  aggregate_table: rollup__date_period__2 {
    query: {
      dimensions: [date_period]
      measures: [returning_visitors, selected_goal_conversion_rate, session_count, totals.bounce_rate, totals.timeonsite_average_per_session, totals.transaction_conversion_rate, unique_visitors]
    }

    materialization: {
      persist_for: "24 hours"
    }
  }

  aggregate_table: rollup__visitStart_date__3 {
    query: {
      dimensions: [visitStart_date]
      measures: [percent_new_users, returning_visitors, selected_goal_conversion_rate, totals.bounce_rate, totals.timeonsite_average_per_session, unique_visitors]
    }

    materialization: {
      persist_for: "24 hours"
    }
  }

  aggregate_table: rollup__channelGrouping__4 {
    query: {
      dimensions: [channelGrouping]
      measures: [percent_new_users, selected_goal_conversion_rate, totals.timeonsite_average_per_session, unique_visitors]
    }

    materialization: {
      persist_for: "24 hours"
    }
  }

  aggregate_table: rollup__trafficSource_medium__5 {
    query: {
      dimensions: [trafficSource.medium]
      measures: [percent_new_users, selected_goal_conversion_rate, totals.timeonsite_average_per_session, unique_visitors]
    }

    materialization: {
      persist_for: "24 hours"
    }
  }

  aggregate_table: rollup__visitStart_day_of_week__visitStart_hour_of_day__6 {
    query: {
      dimensions: [visitStart_day_of_week, visitStart_hour_of_day]
      measures: [session_count]
    }

    materialization: {
      persist_for: "24 hours"
    }
  }

  aggregate_table: rollup__trafficSource_referralPath__7 {
    query: {
      dimensions: [trafficSource.referralPath]
      measures: [percent_new_users, selected_goal_conversion_rate, totals.timeonsite_average_per_session, unique_visitors]
      filters: [trafficSource.referralPath: "-NULL"]
    }

    materialization: {
      persist_for: "24 hours"
    }
  }

  aggregate_table: rollup__geoNetwork_country__8 {
    query: {
      dimensions: [geoNetwork.country]
      measures: [unique_visitors]
      timezone: "America/Los_Angeles"
    }

    materialization: {
      persist_for: "24 hours"
    }
  }

  aggregate_table: rollup__hits_social_socialNetwork__9 {
    query: {
      dimensions: [hits_social.socialNetwork]
      measures: [percent_new_users, selected_goal_conversion_rate, totals.timeonsite_average_per_session, unique_visitors]
    }

    materialization: {
      persist_for: "24 hours"
    }
  }

  aggregate_table: rollup__device_isMobile__10 {
    query: {
      dimensions: [device.isMobile]
      measures: [unique_visitors]
    }

    materialization: {
      persist_for: "24 hours"
    }
  }

  aggregate_table: rollup__trafficSource_keyword__11 {
    query: {
      dimensions: [trafficSource.keyword]
      measures: [percent_new_users, selected_goal_conversion_rate, totals.timeonsite_average_per_session, unique_visitors]
    }

    materialization: {
      persist_for: "24 hours"
    }
  }

  aggregate_table: rollup__first_page_pageTitle__12 {
    query: {
      dimensions: [first_page.pageTitle]
      measures: [percent_new_users, selected_goal_conversion_rate, session_count, totals.bounce_rate, totals.timeonsite_average_per_session]
    }

    materialization: {
      persist_for: "24 hours"
    }
  }

}

view: ga_sessions_config {
  extends: [ga_sessions_template]
  extension: required

# TODO: If the customer has multiple properties use this table name setup. If not see below.
# Multiple properties
# GA360 allows users to apply web tracking to all of their websites. Most companies will only
# have one website so the sql_table_name parameter will simply point to a single table (ga_sessions_*).
# For companies with multiple websites, multiple schemas need to be included in the sql_table_name
# parameter. This pattern is included “sessions.view.lkml” file. Be sure to update the “Property”
# dimension with all the websites as well.

  # TODO: If a customer is only using a single property (one website), change default value to "Yes"
  parameter: single_property {
    default_value: "No"
  }

  sql_table_name:
  (
    SELECT *, 'Property1' as property
    FROM `@{SCHEMA_NAME}.@{GA360_TABLE_NAME}`
    WHERE PARSE_DATE('%Y%m%d', REGEXP_EXTRACT(_TABLE_SUFFIX,r'^\d\d\d\d\d\d\d\d')) >= DATE_ADD(DATE({{ga_sessions.date_period_start_date_comparison_period._sql}}), INTERVAL -1 DAY) AND PARSE_DATE('%Y%m%d', REGEXP_EXTRACT(_TABLE_SUFFIX,r'^\d\d\d\d\d\d\d\d')) <= DATE({{ ga_sessions.date_period_end_date._sql }})
    UNION ALL
    SELECT *, 'Property2' as property
    FROM `@{SCHEMA_NAME}.@{GA360_TABLE_NAME}`
    WHERE PARSE_DATE('%Y%m%d', REGEXP_EXTRACT(_TABLE_SUFFIX,r'^\d\d\d\d\d\d\d\d')) >= DATE_ADD(DATE({{ga_sessions.date_period_start_date_comparison_period._sql}}), INTERVAL -1 DAY) AND PARSE_DATE('%Y%m%d', REGEXP_EXTRACT(_TABLE_SUFFIX,r'^\d\d\d\d\d\d\d\d')) <= DATE({{ ga_sessions.date_period_end_date._sql }})
  );;

# TODO: Update the sql_table_name with the customer’s schema name.
# Single property
  # sql_table_name: `@{SCHEMA_NAME}.@{GA360_TABLE_NAME}` ;;




# TODO: FOR MULTIPLE PROPERTY USE-CASES, USE THE BELOW DIMENSION TO MAP THE WEBSITE NAMES TO THEIR PROPERTIES.

    dimension: property {
      hidden: yes
      suggestions: ["Website1","Website2"]
      sql: CASE
          WHEN ${TABLE}.property = "Property1" THEN "Website1"
          WHEN ${TABLE}.property = "Property2" THEN "Website2"
          ELSE NULL
        END
        ;;
    }

# COMMON FILTERS ACROSS ALL ORGANIZATIONS
# TODO: Customize fileters
# There are three filters outlined in the sessions.view.lkml file - “has_host”, “has_page”, and
# “search_keyword”. By default, these filters pull suggestions from their corresponding dimensions.
# The list of suggestions can get quite large, and often times customers want to limit this. To do so,
# simply hardcode the suggestions in.

    filter: has_host {
      suggestable: yes
      suggest_dimension: hits_page.hostName
      # suggestions: ["hostName1", "hostName2", "…"]
      sql: (SELECT h.page.hostName FROM UNNEST(${ga_sessions.hits}) h
        WHERE {%condition %} h.page.hostName {%endcondition%} LIMIT 1) IS NOT NULL ;;
    }


    filter: has_page {
      suggestable: yes
      suggest_dimension: hits_page.pageTitle
      sql: (SELECT h.page.pageTitle FROM UNNEST(${ga_sessions.hits}) h
        WHERE {%condition %} h.page.pageTitle {%endcondition%} LIMIT 1) IS NOT NULL ;;
    }

    filter: search_keyword {
      suggestable: yes
      suggest_dimension: trafficSource.keyword
      sql: (SELECT h.keyword FROM UNNEST([${ga_sessions.trafficSource}]) h
        WHERE {%condition %} h.keyword {%endcondition%} LIMIT 1) IS NOT NULL ;;
    }



# TODO: CUSTOMIZE GOALS HERE ####

# Goals measure how well your site or app fulfills your target objectives. A goal represents a completed activity,
# called a conversion, that contributes to the success of your business. Examples of goals include making a purchase
# (for an ecommerce site), completing a game level (for a mobile gaming app), or submitting a contact information
# form (for a marketing or lead generation site).

# Find more information here: https://support.google.com/analytics/answer/1012040?hl=en&ref_topic=6150889

# "Selected_goal_conversions", "selected_goal_conversion_rate", and "selected_goal_conversion_value" are the
# measures used in the application interface. Make sure that these measures contain all of the possible goals.
# The goal will be selected using a filter in the Application UI.


    # goal definitions

    dimension: demo_goal_hit {
      type: yesno
      sql: (SELECT h.page.pagePath FROM UNNEST(${ga_sessions.hits}) h
        WHERE h.page.pagePath = "/asearch.html" LIMIT 1) IS NOT NULL ;;
    }

    dimension: company_goal_hit {
      type: yesno
      sql: (SELECT h.page.pagePath FROM UNNEST(${ga_sessions.hits}) h
        WHERE h.page.pagePath = "/company" LIMIT 1) IS NOT NULL ;;
    }

    dimension: team_goal_hit {
      type: yesno
      sql: (SELECT h.page.pagePath FROM UNNEST(${ga_sessions.hits}) h
        WHERE h.page.pagePath = "/team" LIMIT 1) IS NOT NULL ;;
    }


    dimension: home_page_goal {
      type: yesno
      sql: (SELECT h.page.pagePath FROM UNNEST(${ga_sessions.hits}) h
        WHERE h.page.pagePath = "/goal" LIMIT 1) IS NOT NULL ;;
    }

    dimension: about_page_goal {
      type: yesno
      sql: (SELECT h.page.pagePath FROM UNNEST(${ga_sessions.hits}) h
        WHERE h.page.pagePath = "/about" LIMIT 1) IS NOT NULL ;;
    }

    dimension: conversion_value {
      sql: 100 ;;
    }


    # value of goal

    dimension: value_of_conversion {
      type: number
      hidden: yes
      sql: 100 ;;
      value_format_name: usd
    }

    # filter for goal completion to mark as converted

    measure: demo_goal_conversions {
      group_label: "Goals"
      type: count
      filters: {
        field: demo_goal_hit
        value: "Yes"
      }
    }

    measure: company_goal_conversions {
      group_label: "Goals"
      type: count
      filters: {
        field: company_goal_hit
        value: "Yes"
      }
    }

    # define conversion rate

    measure: demo_goal_conversion_rate {
      description: "URL hits / Sessions"
      group_label: "Goals"
      type: number
      sql: 1.0 * (${demo_goal_conversions}/NULLIF(${ga_sessions.session_count},0));;
      value_format_name: percent_2
    }

    measure: company_goal_conversion_rate {
      description: "URL hits / Sessions"
      group_label: "Goals"
      type: number
      sql: 1.0 * (${company_goal_conversions}/NULLIF(${ga_sessions.session_count},0));;
      value_format_name: percent_2
    }

    measure: demo_goal_conversion_value {
      description: "URL Conversions * Value"
      group_label: "Goals"
      type: number
      sql: 1.0 * (${demo_goal_conversions}) * (${value_of_conversion});;
      value_format_name: usd
    }

    measure: company_goal_conversion_value {
      description: "URL Conversions * Value"
      group_label: "Goals"
      type: number
      sql: 1.0 * (${company_goal_conversions}) * (${value_of_conversion});;
      value_format_name: usd
    }

    # TODO: you need to add all the goals here as well

    parameter: goal_selection {
      type: string
      suggestions: ["No Selection","Demo","Company"]
      allowed_value: {value: "No Selection"}
      allowed_value: {value: "Demo"}
      allowed_value: {value: "Company"}
      default_value: "'No Selection'"
    }

    measure: selected_goal_conversions {
      type: number
      sql: {% if goal_selection._parameter_value == "'Demo'" %}${demo_goal_conversions}
          {% elsif goal_selection._parameter_value == "'Company'" %}${company_goal_conversions}
          {% elsif goal_selection._parameter_value == "'No Selection'" %}NULL
          {% endif %} ;;
      label_from_parameter: goal_selection
      value_format_name: decimal_0
    }

    measure: selected_goal_conversion_rate {
      type: number
      sql: {% if goal_selection._parameter_value == "'Demo'" %}${demo_goal_conversion_rate}
         {% elsif goal_selection._parameter_value == "'Company'" %}${company_goal_conversion_rate}
         {% elsif goal_selection._parameter_value == "'No Selection'" %}NULL
          {% endif %} ;;
      label_from_parameter: goal_selection
      value_format_name: percent_2
    }

    measure: selected_goal_conversion_value {
      type: number
      sql: {% if goal_selection._parameter_value == "'Demo'" %}${demo_goal_conversion_value}
         {% elsif goal_selection._parameter_value == "'Company'" %}${company_goal_conversion_value}
         {% elsif goal_selection._parameter_value == "'No Selection'" %}NULL
          {% endif %} ;;
      label_from_parameter: goal_selection
      value_format_name: usd
    }



  }
