# Try it
```
ruby csv_segmentation.rb small_scale_export.csv small_scale_schema.csv
or
ruby csv_segmentation.rb sample_export.csv seg_schema.csv
```


##### Desc: UPMC is requesting the ability/feature to:
  - Split a large CSV logically.
  - Have columns that link the csvs together.
  - Upload it to an SFTP folder for them to pull from.
  - Automate this process on a timer(cron/rake scheduling).
  - Once automated, consider sending the incremental diffs.

After discussing with Steph and Toaha, the last 2 points seem out of scope for this particular project/spike.
  - These features could/should(?) be implemented across the board for export/extract anyways, regardless of UPMC.
  - These features are "known" to us, which is to say that we have a pattern worked out to do such a thing.

Because of this, I focused on the first 3 points
  - Splitting up a large CSV logically + linking the columns:
    - After considering a few options, to make this as generic as possible for future clients, I went with a secondary csv that serves as a schema.  This CSV would have 2 rows, the first being all headers, second being the logical division we're looking for.  [Small Scale Schema Example](https://github.com/dompham/csv_segmentation/blob/master/small_scale_schema.csv)
	- Each number in the second row designates the nTh csv that the particular column will be split to.  In my rough schema, things designated "R" for reapeater will be moved to the front and exist in all CSVs to tie them in.
  - To be usable, I think there should be a generate schema button that downloads a schema file with the headers relevant to your reg config.

  	- I put together a quick demo on how this could be done.  Depending on how intensely we think this split option will be used, I think there could be a discussion about *when* the splitting happens.  For simplicity, I made this service as the last step in our extract pipeline (Splitting an extract after* its been written).  If we really invest in this feature, then I think it makes the most sense to have this service as a fork in our pipeline - Either we logically split OR we write the whole csv, not both. This approach is more developer intensive but efficient.


- SFTP:
	- Using net-sftp was pretty painless, just need to know the normal stuff: host, user, password, local file, remote dest.  Pic attached.
![sftp](https://github.com/dompham/csv_segmentation/blob/master/ezpzsftp.png)
