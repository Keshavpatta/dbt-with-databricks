WITH return_table as
    (
        select 
            sales_id,
            product_sk,
            returned_qty,
            refund_amount,
            return_reason
        from
            {{ ref('bronze_return') }}
    ),

    products as
    (
        select
            product_sk,
            category
        from
            {{ ref('bronze_product') }}
    ),

    sales as
    (
        select
            sales_id,
            customer_sk
        from
            {{ ref('bronze_sales') }}
    ),

    customers as
    (
        select 
            customer_sk,
            gender
        from
            {{ ref('bronze_customer') }}
    ),
    silver_return as
    (
        select 
            return_table.sales_id,
            products.category,
            return_table.returned_qty,
            return_table.refund_amount,
            return_table.return_reason,
            sales.customer_sk,
            customers.gender
        from
            return_table
        join products on return_table.product_sk=products.product_sk
        join sales on return_table.sales_id=sales.sales_id
        join customers on sales.customer_sk=customers.customer_sk
    )

    select category,gender,sum(refund_amount) as total_refund
    from silver_return
    group by category,gender
    order by total_refund desc