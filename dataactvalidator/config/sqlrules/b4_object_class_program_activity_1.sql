-- ObligationsDeliveredOrdersUnpaidTotal (FYB) = USSGL 4901. This applies to the program activity and object class
-- level.
SELECT
    row_number,
    obligations_delivered_orde_fyb,
    ussgl490100_delivered_orde_fyb,
    COALESCE(obligations_delivered_orde_fyb, 0) - COALESCE(ussgl490100_delivered_orde_fyb, 0) AS "difference",
    tas AS "uniqueid_TAS",
    program_activity_code AS "uniqueid_ProgramActivityCode",
    object_class AS "uniqueid_ObjectClass"
FROM object_class_program_activity
WHERE submission_id = {0}
    AND COALESCE(obligations_delivered_orde_fyb, 0) <> COALESCE(ussgl490100_delivered_orde_fyb, 0);
