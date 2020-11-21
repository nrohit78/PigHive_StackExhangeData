-- Few IDs are deliberately removed to avoid data duplication. This avoids skipping records and duplication at the same time

select TOP 50000 * from posts where posts.ViewCount > 110000 ORDER BY posts.ViewCount DESC;

select TOP 50000 * from posts 
where posts.ViewCount < 112524 AND posts.ViewCount > 60000 AND posts.Id != 904910 
ORDER BY posts.ViewCount DESC;

select TOP 50000 * from posts 
where posts.ViewCount < 66244 AND posts.ViewCount > 45000 AND posts.Id != 20482207 
ORDER BY posts.ViewCount DESC;

select TOP 50000 * from posts 
where posts.ViewCount < 47291 AND posts.ViewCount > 30000 AND posts.Id not in (24853847,45351434,488811,2293592,14476448) 
ORDER BY posts.ViewCount DESC;
