WITH aw_pafa AS
    (SELECT DISTINCT ON (
            pafa.fain
        )
        pafa.fain AS fain,
        pafa.uri AS uri,
        pafa.award_description AS award_description,
        pafa.record_type AS record_type,
        pafa.awarding_agency_code AS awarding_agency_code,
        pafa.awarding_agency_name AS awarding_agency_name,
        pafa.awarding_office_code AS awarding_office_code,
        pafa.awarding_office_name AS awarding_office_name,
        pafa.funding_agency_code AS funding_agency_code,
        pafa.funding_agency_name AS funding_agency_name,
        pafa.funding_office_code AS funding_office_code,
        pafa.funding_office_name AS funding_office_name,
        pafa.business_types_desc AS business_types_desc,
        pafa.awarding_sub_tier_agency_c AS awarding_sub_tier_agency_c,
        pafa.awarding_sub_tier_agency_n AS awarding_sub_tier_agency_n,
        pafa.funding_sub_tier_agency_co AS funding_sub_tier_agency_co,
        pafa.funding_sub_tier_agency_na AS funding_sub_tier_agency_na,
        pafa.unique_award_key AS unique_award_key
    FROM published_award_financial_assistance AS pafa
    WHERE is_active IS TRUE
        AND EXISTS (
            SELECT 1
            FROM fsrs_grant
            WHERE fsrs_grant.fain = pafa.fain
                AND fsrs_grant.id {0} {1}
        )
    ORDER BY pafa.fain, pafa.action_date),
grant_pduns AS
    (SELECT grand_pduns_from.awardee_or_recipient_uniqu AS awardee_or_recipient_uniqu,
        grand_pduns_from.legal_business_name AS legal_business_name
    FROM (
        SELECT duns.awardee_or_recipient_uniqu AS awardee_or_recipient_uniqu,
            duns.legal_business_name AS legal_business_name,
            row_number() OVER (PARTITION BY
                duns.awardee_or_recipient_uniqu
            ) AS row
        FROM fsrs_grant
            LEFT OUTER JOIN duns
                ON fsrs_grant.parent_duns = duns.awardee_or_recipient_uniqu
                AND fsrs_grant.id {0} {1}
        ORDER BY duns.activation_date DESC
     ) AS grand_pduns_from
    WHERE grand_pduns_from.row = 1),
subgrant_pduns AS (
    SELECT sub_pduns_from.awardee_or_recipient_uniqu AS awardee_or_recipient_uniqu,
        sub_pduns_from.legal_business_name AS legal_business_name
    FROM (
        SELECT duns.awardee_or_recipient_uniqu AS awardee_or_recipient_uniqu,
            duns.legal_business_name AS legal_business_name,
            row_number() OVER (PARTITION BY
                duns.awardee_or_recipient_uniqu
            ) AS row
        FROM fsrs_subgrant
            LEFT OUTER JOIN duns
                ON fsrs_subgrant.parent_duns = duns.awardee_or_recipient_uniqu
                AND fsrs_subgrant.parent_id {0} {1}
        ORDER BY duns.activation_date DESC
    ) AS sub_pduns_from
    WHERE sub_pduns_from.row = 1),
subgrant_duns AS (
    SELECT sub_duns_from.awardee_or_recipient_uniqu AS awardee_or_recipient_uniqu,
        sub_duns_from.business_types_codes AS business_types_codes
    FROM (
        SELECT
            duns.awardee_or_recipient_uniqu AS awardee_or_recipient_uniqu,
            duns.business_types_codes AS business_types_codes,
            row_number() OVER (PARTITION BY
                duns.awardee_or_recipient_uniqu
            ) AS row
        FROM fsrs_subgrant
            LEFT OUTER JOIN duns
                ON fsrs_subgrant.duns = duns.awardee_or_recipient_uniqu
                AND fsrs_subgrant.parent_id {0} {1}
        ORDER BY duns.activation_date DESC
    ) AS sub_duns_from
    WHERE sub_duns_from.row = 1)
INSERT INTO subaward (
    "unique_award_key",
    "award_id",
    "parent_award_id",
    "award_amount",
    "action_date",
    "fy",
    "awarding_agency_code",
    "awarding_agency_name",
    "awarding_sub_tier_agency_c",
    "awarding_sub_tier_agency_n",
    "awarding_office_code",
    "awarding_office_name",
    "funding_agency_code",
    "funding_agency_name",
    "funding_sub_tier_agency_co",
    "funding_sub_tier_agency_na",
    "funding_office_code",
    "funding_office_name",
    "awardee_or_recipient_uniqu",
    "awardee_or_recipient_legal",
    "dba_name",
    "ultimate_parent_unique_ide",
    "ultimate_parent_legal_enti",
    "legal_entity_country_code",
    "legal_entity_country_name",
    "legal_entity_address_line1",
    "legal_entity_city_name",
    "legal_entity_state_code",
    "legal_entity_state_name",
    "legal_entity_zip",
    "legal_entity_congressional",
    "legal_entity_foreign_posta",
    "business_types",
    "place_of_perform_city_name",
    "place_of_perform_state_code",
    "place_of_perform_state_name",
    "place_of_performance_zip",
    "place_of_perform_congressio",
    "place_of_perform_country_co",
    "place_of_perform_country_na",
    "award_description",
    "naics",
    "naics_description",
    "cfda_numbers",
    "cfda_titles",
    "subaward_type",
    "subaward_report_year",
    "subaward_report_month",
    "subaward_number",
    "subaward_amount",
    "sub_action_date",
    "sub_awardee_or_recipient_uniqu",
    "sub_awardee_or_recipient_legal",
    "sub_dba_name",
    "sub_ultimate_parent_unique_ide",
    "sub_ultimate_parent_legal_enti",
    "sub_legal_entity_country_code",
    "sub_legal_entity_country_name",
    "sub_legal_entity_address_line1",
    "sub_legal_entity_city_name",
    "sub_legal_entity_state_code",
    "sub_legal_entity_state_name",
    "sub_legal_entity_zip",
    "sub_legal_entity_congressional",
    "sub_legal_entity_foreign_posta",
    "sub_business_types",
    "sub_place_of_perform_city_name",
    "sub_place_of_perform_state_code",
    "sub_place_of_perform_state_name",
    "sub_place_of_performance_zip",
    "sub_place_of_perform_congressio",
    "sub_place_of_perform_country_co",
    "sub_place_of_perform_country_na",
    "subaward_description",
    "sub_high_comp_officer1_full_na",
    "sub_high_comp_officer1_amount",
    "sub_high_comp_officer2_full_na",
    "sub_high_comp_officer2_amount",
    "sub_high_comp_officer3_full_na",
    "sub_high_comp_officer3_amount",
    "sub_high_comp_officer4_full_na",
    "sub_high_comp_officer4_amount",
    "sub_high_comp_officer5_full_na",
    "sub_high_comp_officer5_amount",
    "prime_id",
    "internal_id",
    "date_submitted",
    "report_type",
    "transaction_type",
    "program_title",
    "contract_agency_code",
    "contract_idv_agency_code",
    "grant_funding_agency_id",
    "grant_funding_agency_name",
    "federal_agency_name",
    "treasury_symbol",
    "dunsplus4",
    "recovery_model_q1",
    "recovery_model_q2",
    "compensation_q1",
    "compensation_q2",
    "high_comp_officer1_full_na",
    "high_comp_officer1_amount",
    "high_comp_officer2_full_na",
    "high_comp_officer2_amount",
    "high_comp_officer3_full_na",
    "high_comp_officer3_amount",
    "high_comp_officer4_full_na",
    "high_comp_officer4_amount",
    "high_comp_officer5_full_na",
    "high_comp_officer5_amount",
    "sub_id",
    "sub_parent_id",
    "sub_federal_agency_id",
    "sub_federal_agency_name",
    "sub_funding_agency_id",
    "sub_funding_agency_name",
    "sub_funding_office_id",
    "sub_funding_office_name",
    "sub_naics",
    "sub_cfda_numbers",
    "sub_dunsplus4",
    "sub_recovery_subcontract_amt",
    "sub_recovery_model_q1",
    "sub_recovery_model_q2",
    "sub_compensation_q1",
    "sub_compensation_q2",
    "created_at",
    "updated_at"
)
SELECT
    -- File F Prime Awards
    aw_pafa.unique_award_key AS "unique_award_key",
    grant_filtered.fain AS "award_id",
    NULL AS "parent_award_id",
    grant_filtered.total_fed_funding_amount AS "award_amount",
    grant_filtered.obligation_date AS "action_date",
    'FY' || fy(obligation_date) AS "fy",
    aw_pafa.awarding_agency_code AS "awarding_agency_code",
    aw_pafa.awarding_agency_name AS "awarding_agency_name",
    grant_filtered.federal_agency_id AS "awarding_sub_tier_agency_c",
    aw_pafa.awarding_sub_tier_agency_n AS "awarding_sub_tier_agency_n",
    aw_pafa.awarding_office_code AS "awarding_office_code",
    aw_pafa.awarding_office_name AS "awarding_office_name",
    aw_pafa.funding_agency_code AS "funding_agency_code",
    aw_pafa.funding_agency_name AS "funding_agency_name",
    aw_pafa.funding_sub_tier_agency_co AS "funding_sub_tier_agency_co",
    aw_pafa.funding_sub_tier_agency_na AS "funding_sub_tier_agency_na",
    aw_pafa.funding_office_code AS "funding_office_code",
    aw_pafa.funding_office_name AS "funding_office_name",
    grant_filtered.duns AS "awardee_or_recipient_uniqu",
    grant_filtered.awardee_name AS "awardee_or_recipient_legal",
    grant_filtered.dba_name AS "dba_name",
    grant_filtered.parent_duns AS "ultimate_parent_unique_ide",
    grant_pduns.legal_business_name AS "ultimate_parent_legal_enti",
    grant_filtered.awardee_address_country AS "legal_entity_country_code",
    le_country.country_name AS "legal_entity_country_name",
    grant_filtered.awardee_address_street AS "legal_entity_address_line1",
    grant_filtered.awardee_address_city AS "legal_entity_city_name",
    grant_filtered.awardee_address_state AS "legal_entity_state_code",
    grant_filtered.awardee_address_state_name AS "legal_entity_state_name",
    CASE WHEN grant_filtered.awardee_address_country = 'USA'
         THEN grant_filtered.awardee_address_zip
         ELSE NULL
    END AS "legal_entity_zip",
    grant_filtered.awardee_address_district AS "legal_entity_congressional",
    CASE WHEN grant_filtered.awardee_address_country <> 'USA'
        THEN grant_filtered.awardee_address_zip
        ELSE NULL
    END AS "legal_entity_foreign_posta",
    aw_pafa.business_types_desc AS "business_types",
    grant_filtered.principle_place_city AS "place_of_perform_city_name",
    grant_filtered.principle_place_state AS "place_of_perform_state_code",
    grant_filtered.principle_place_state_name AS "place_of_perform_state_name",
    grant_filtered.principle_place_zip AS "place_of_performance_zip",
    grant_filtered.principle_place_district AS "place_of_perform_congressio",
    grant_filtered.principle_place_country AS "place_of_perform_country_co",
    ppop_country.country_name AS "place_of_perform_country_na",
    grant_filtered.project_description AS "award_description",
    NULL AS "naics",
    NULL AS "naics_description",
    CASE WHEN grant_filtered.cfda_numbers ~ ';'
         THEN cfda_num_loop(grant_filtered.cfda_numbers)
         ELSE cfda_num(grant_filtered.cfda_numbers)
    END AS "cfda_numbers",
    CASE WHEN grant_filtered.cfda_numbers ~ ';'
         THEN cfda_word_loop(grant_filtered.cfda_numbers)
         ELSE cfda_word(grant_filtered.cfda_numbers)
    END AS "cfda_titles",

    -- File F Subawards
    'sub-grant' AS "subaward_type",
    grant_filtered.report_period_year AS "subaward_report_year",
    grant_filtered.report_period_mon AS "subaward_report_month",
    fsrs_subgrant.subaward_num AS "subaward_number",
    fsrs_subgrant.subaward_amount AS "subaward_amount",
    fsrs_subgrant.subaward_date AS "sub_action_date",
    fsrs_subgrant.duns AS "sub_awardee_or_recipient_uniqu",
    fsrs_subgrant.awardee_name AS "sub_awardee_or_recipient_legal",
    fsrs_subgrant.dba_name AS "sub_dba_name",
    fsrs_subgrant.parent_duns AS "sub_ultimate_parent_unique_ide",
    subgrant_pduns.legal_business_name AS "sub_ultimate_parent_legal_enti",
    fsrs_subgrant.awardee_address_country AS "sub_legal_entity_country_code",
    sub_le_country.country_name AS "sub_legal_entity_country_name",
    fsrs_subgrant.awardee_address_street AS "sub_legal_entity_address_line1",
    fsrs_subgrant.awardee_address_city AS "sub_legal_entity_city_name",
    fsrs_subgrant.awardee_address_state AS "sub_legal_entity_state_code",
    fsrs_subgrant.awardee_address_state_name AS "sub_legal_entity_state_name",
    CASE WHEN fsrs_subgrant.awardee_address_country = 'USA'
         THEN fsrs_subgrant.awardee_address_zip
         ELSE NULL
    END AS "sub_legal_entity_zip",
    fsrs_subgrant.awardee_address_district AS "sub_legal_entity_congressional",
    CASE WHEN fsrs_subgrant.awardee_address_country <> 'USA'
         THEN fsrs_subgrant.awardee_address_zip
         ELSE NULL
    END AS "sub_legal_entity_foreign_posta",
    array_to_string(subgrant_duns.business_types_codes, ', ') AS "sub_business_types",
    fsrs_subgrant.principle_place_city AS "sub_place_of_perform_city_name",
    fsrs_subgrant.principle_place_state AS "sub_place_of_perform_state_code",
    fsrs_subgrant.principle_place_state_name AS "sub_place_of_perform_state_name",
    fsrs_subgrant.principle_place_zip AS "sub_place_of_performance_zip",
    fsrs_subgrant.principle_place_district AS "sub_place_of_perform_congressio",
    fsrs_subgrant.principle_place_country AS "sub_place_of_perform_country_co",
    sub_ppop_country.country_name AS "sub_place_of_perform_country_na",
    fsrs_subgrant.project_description AS "subaward_description",
    fsrs_subgrant.top_paid_fullname_1 AS "sub_high_comp_officer1_full_na",
    fsrs_subgrant.top_paid_amount_1 AS "sub_high_comp_officer1_amount",
    fsrs_subgrant.top_paid_fullname_2 AS "sub_high_comp_officer2_full_na",
    fsrs_subgrant.top_paid_amount_2 AS "sub_high_comp_officer2_amount",
    fsrs_subgrant.top_paid_fullname_3 AS "sub_high_comp_officer3_full_na",
    fsrs_subgrant.top_paid_amount_3 AS "sub_high_comp_officer3_amount",
    fsrs_subgrant.top_paid_fullname_4 AS "sub_high_comp_officer4_full_na",
    fsrs_subgrant.top_paid_amount_4 AS "sub_high_comp_officer4_amount",
    fsrs_subgrant.top_paid_fullname_5 AS "sub_high_comp_officer5_full_na",
    fsrs_subgrant.top_paid_amount_5 AS "sub_high_comp_officer5_amount",

    -- File F Prime Awards
    grant_filtered.id AS "prime_id",
    grant_filtered.internal_id AS "internal_id",
    grant_filtered.date_submitted AS "date_submitted",
    NULL AS "report_type",
    NULL AS "transaction_type",
    NULL AS "program_title",
    NULL AS "contract_agency_code",
    NULL AS "contract_idv_agency_code",
    grant_filtered.funding_agency_id AS "grant_funding_agency_id",
    grant_filtered.funding_agency_name AS "grant_funding_agency_name",
    grant_filtered.federal_agency_name AS "federal_agency_name",
    NULL AS "treasury_symbol",
    grant_filtered.dunsplus4 AS "dunsplus4",
    NULL AS "recovery_model_q1",
    NULL AS "recovery_model_q2",
    grant_filtered.compensation_q1 AS "compensation_q1",
    grant_filtered.compensation_q2 AS "compensation_q2",
    grant_filtered.top_paid_fullname_1 AS "high_comp_officer1_full_na",
    grant_filtered.top_paid_amount_1 AS "high_comp_officer1_amount",
    grant_filtered.top_paid_fullname_2 AS "high_comp_officer2_full_na",
    grant_filtered.top_paid_amount_2 AS "high_comp_officer2_amount",
    grant_filtered.top_paid_fullname_3 AS "high_comp_officer3_full_na",
    grant_filtered.top_paid_amount_3 AS "high_comp_officer3_amount",
    grant_filtered.top_paid_fullname_4 AS "high_comp_officer4_full_na",
    grant_filtered.top_paid_amount_4 AS "high_comp_officer4_amount",
    grant_filtered.top_paid_fullname_5 AS "high_comp_officer5_full_na",
    grant_filtered.top_paid_amount_5 AS "high_comp_officer5_amount",

    -- File F Subawards
    fsrs_subgrant.id AS "sub_id",
    fsrs_subgrant.parent_id AS "sub_parent_id",
    fsrs_subgrant.federal_agency_id AS "sub_federal_agency_id",
    fsrs_subgrant.federal_agency_name AS "sub_federal_agency_name",
    fsrs_subgrant.funding_agency_id AS "sub_funding_agency_id",
    fsrs_subgrant.funding_agency_name AS "sub_funding_agency_name",
    NULL AS "sub_funding_office_id",
    NULL AS "sub_funding_office_name",
    NULL AS "sub_naics",
    fsrs_subgrant.cfda_numbers AS "sub_cfda_numbers",
    fsrs_subgrant.dunsplus4 AS "sub_dunsplus4",
    NULL AS "sub_recovery_subcontract_amt",
    NULL AS "sub_recovery_model_q1",
    NULL AS "sub_recovery_model_q2",
    fsrs_subgrant.compensation_q1 AS "sub_compensation_q1",
    fsrs_subgrant.compensation_q2 AS "sub_compensation_q2",
    NOW() AS "created_at",
    NOW() AS "updated_at"

FROM grant_filtered
    JOIN fsrs_subgrant
        ON fsrs_subgrant.parent_id = grant_filtered.id
    LEFT OUTER JOIN aw_pafa
        ON grant_filtered.fain = aw_pafa.fain
    LEFT OUTER JOIN country_code AS le_country
        ON grant_filtered.awardee_address_country = le_country.country_code
    LEFT OUTER JOIN country_code AS ppop_country
        ON grant_filtered.principle_place_country = ppop_country.country_code
    LEFT OUTER JOIN country_code AS sub_le_country
        ON fsrs_subgrant.awardee_address_country = sub_le_country.country_code
    LEFT OUTER JOIN country_code AS sub_ppop_country
        ON fsrs_subgrant.principle_place_country = sub_ppop_country.country_code
    LEFT OUTER JOIN grant_pduns
        ON grant_filtered.parent_duns = grant_pduns.awardee_or_recipient_uniqu
    LEFT OUTER JOIN subgrant_pduns
        ON fsrs_subgrant.parent_duns = subgrant_pduns.awardee_or_recipient_uniqu
    LEFT OUTER JOIN subgrant_duns
        ON fsrs_subgrant.duns = subgrant_duns.awardee_or_recipient_uniqu
