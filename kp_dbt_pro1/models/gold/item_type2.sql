with dedup_query as
(
    select 
    *,
    row_number() over(partition by id order by updatedDate desc) as duplication_id
    from
    {{ source('source', 'items') }}
)

select id, name, category,updateddate from dedup_query
where duplication_id=1