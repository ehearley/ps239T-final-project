
# 1. Accessing Twitter API
### Elisabeth Earley


```python
#Import required packages
import tweepy
import json
import csv
import pandas as pd
import datetime
import time
```


```python
print("Last run: " + str(pd.to_datetime('today')))
```

    Last run: 2018-04-23 00:00:00
    


```python
access_token = 'XXXXXXXXXXXXXXXX'
access_token_secret = 'XXXXXXXXXXXXXXXXXXX'
consumer_key = 'XXXXXXXXXXXXXXXX'
consumer_secret = 'XXXXXXXXXXXXXXXX'

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

API = tweepy.API(auth, wait_on_rate_limit=True, wait_on_rate_limit_notify=True)
```


```python
elites = {'Alvaro Uribe Velez':'@AlvaroUribeVel', 'Sergio Fajardo':'@sergio_fajardo', \
'Gustavo Petro':'@petrogustavo', 'Ivan Duque Marquez':'@IvanDuque', 'German Vargas Lleras':'@German_Vargas', \
'Juan Manuel Santos':'@juanmansantos', 'Humberto de la Calle':'@DeLaCalleHum'}
names = elites.keys()
handles = elites.values()
```


```python
profiles = {}
for user in elites:
    profiles[user] = API.get_user(elites[user])
```

# A) Elite "followers"
[Still under construction...each candidate can hve up to 5 million followers. I can only
grab 5000 ID's at a time and can only use those ID's to pull profiles 900 at at time. It would take 13 days to process 1 million followers. Pulling profiles directly can only be done 200 at a time which would take 52 days for 1 million followers.


```python
follow_id_dict = {}
for user in elites:
    follow_id_dict[user] = API.followers_ids(elites[user], cursor=-1, count=5000)
    
```

Example of ID list. From the above loop, each candidate has 5000 follower IDs in their list.


```python
print((follow_id_dict['Gustavo Petro'][0][:20]))
```

    [988687871673622528, 988687996529598465, 988687296227692544, 988686975950639104, 139164299, 986464756117725185, 804570031, 988526901089177600, 443798852, 988685213768265728, 742544146599170048, 519745004, 2364116309, 943322239251906560, 113583414, 988680121124052992, 1058936515, 988677731901636608, 184560506, 988672139120214017]
    

# B) Elite "followings" (aka "friends")
1. Gather ID #'s for the accounts that each elite is following 
2. Use ID's to quickly pull user information
3. Save id, name, screen_name, location, created_at, friends_count, followers_count into csv for each elite


```python
friend_id_dict = {}
for user in elites:
    friend_id_dict[user] = API.friends_ids(elites[user])
    
#Create a dictionary for the total list of 'friends' IDs, where each elite has their own list.
```


```python
#These are the numbers of IDs that we should be pulling. More for some than others.
for name in names:
    print("Total friends for: " + name)
    print(profiles[name].friends_count)
    print('\n')
    
```

### Create function that downloads specific variables from each 'friend's' profile, writing the data into a csv file
**Expected time: 2.64 hours**

1. Create empty dictionary to store an empty list for every elite.
2. Create an empty csv ('friends.csv') in sublime to avoid the meta-data created by opening a new file in excel.
3. Using empty csv and encoding in utf-8 to avoid the loop breaking due to emojis, create columns for the variables i'm interested in taking from each 'friend'
4. Loops through the ID numbers for each elite's friends list and grabs the 'friend' profile
5. Allow the loop to append 'friend' profiles to the respective empty list within the main dictionary (userlist)
6. Create a dictionary holding each column's information (row_dict)
7. Allow the csv to be written using the row_dict data 


```python
userlist = {}
with open('friends.csv', 'w', encoding='utf-8') as csvfile:
    fieldnames = ['elite', 'id', 'name', 'screen_name', 'location', 'created_at', 'friends_count', 'followers_count']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()
    
    for name in list(elites.keys()):
        userlist[name] = []
        for id_no in friend_id_dict[name]:
            print(name, id_no)
            friend_data = API.get_user(id_no)
            userlist[name].append(friend_data)
            row_dict = {}
            row_dict['elite'] = name
            row_dict['id'] = id_no
            row_dict['name'] = friend_data.name
            row_dict['screen_name'] = friend_data.screen_name
            row_dict['location'] = friend_data.location
            row_dict['created_at'] = friend_data.created_at
            row_dict['friends_count'] = friend_data.friends_count
            row_dict['followers_count'] = friend_data.followers_count
            writer.writerow(row_dict)
        
```

    Alvaro Uribe Velez 959979685844324352
    Alvaro Uribe Velez 188794797
    Alvaro Uribe Velez 444864072
    Alvaro Uribe Velez 235307099
    Alvaro Uribe Velez 924605888
    Alvaro Uribe Velez 944069706000068608
    Alvaro Uribe Velez 718110470
    Alvaro Uribe Velez 271489997
    Alvaro Uribe Velez 971873261767229442
    Alvaro Uribe Velez 708108228568207360
    Alvaro Uribe Velez 148841952
    Alvaro Uribe Velez 334964709
    Alvaro Uribe Velez 2270879984
    Alvaro Uribe Velez 2988481305
    Alvaro Uribe Velez 140139017
    Alvaro Uribe Velez 114349252
    Alvaro Uribe Velez 1340762509
    Alvaro Uribe Velez 158254831
    Alvaro Uribe Velez 938420001597526016
    Alvaro Uribe Velez 178907052
    Alvaro Uribe Velez 752373176
    Alvaro Uribe Velez 1389451004
    Alvaro Uribe Velez 1004846934
    Alvaro Uribe Velez 945328959071408128
    Alvaro Uribe Velez 529366113
    Alvaro Uribe Velez 53558873
    Alvaro Uribe Velez 2382410672
    Alvaro Uribe Velez 2834117261
    Alvaro Uribe Velez 555606359
    Alvaro Uribe Velez 884893275865350144
    Alvaro Uribe Velez 219450719
    Alvaro Uribe Velez 110456347
    Alvaro Uribe Velez 297807828
    Alvaro Uribe Velez 2890024156
    Alvaro Uribe Velez 848368682669572097
    Alvaro Uribe Velez 265752992
    Alvaro Uribe Velez 241304303
    Alvaro Uribe Velez 3074040677
    Alvaro Uribe Velez 603793165
    Alvaro Uribe Velez 2568262859
    Alvaro Uribe Velez 982240622613442560
    Alvaro Uribe Velez 114299534
    Alvaro Uribe Velez 438392655
    Alvaro Uribe Velez 982072241306329089
    Alvaro Uribe Velez 220868442
    Alvaro Uribe Velez 2862503751
    Alvaro Uribe Velez 232388741
    Alvaro Uribe Velez 207714655
    Alvaro Uribe Velez 129683990
    Alvaro Uribe Velez 204602499
    Alvaro Uribe Velez 256161747
    Alvaro Uribe Velez 284221403
    Alvaro Uribe Velez 912794510761037826
    Alvaro Uribe Velez 976974286459203584
    Alvaro Uribe Velez 25185308
    Alvaro Uribe Velez 1027270314
    Alvaro Uribe Velez 902951520
    Alvaro Uribe Velez 1954256576
    Alvaro Uribe Velez 625792839
    Alvaro Uribe Velez 61948198
    Alvaro Uribe Velez 97003915
    Alvaro Uribe Velez 2390678402
    Alvaro Uribe Velez 977197427185897472
    Alvaro Uribe Velez 287794209
    Alvaro Uribe Velez 905815659023663106
    Alvaro Uribe Velez 778987386667663362
    Alvaro Uribe Velez 923690661299347458
    Alvaro Uribe Velez 76160583
    Alvaro Uribe Velez 1253016337
    Alvaro Uribe Velez 1093456969
    Alvaro Uribe Velez 915660768598724608
    Alvaro Uribe Velez 535715977
    Alvaro Uribe Velez 908139045988990982
    Alvaro Uribe Velez 187492884
    Alvaro Uribe Velez 568802393
    Alvaro Uribe Velez 210176016
    Alvaro Uribe Velez 2684210810
    Alvaro Uribe Velez 156955271
    Alvaro Uribe Velez 262886382
    Alvaro Uribe Velez 266582991
    Alvaro Uribe Velez 142321686
    Alvaro Uribe Velez 973570582058020865
    Alvaro Uribe Velez 1631073337
    Alvaro Uribe Velez 2500233432
    Alvaro Uribe Velez 2823085419
    Alvaro Uribe Velez 2406379355
    Alvaro Uribe Velez 126065365
    Alvaro Uribe Velez 712251347995860992
    Alvaro Uribe Velez 38696326
    Alvaro Uribe Velez 894956198759469057
    Alvaro Uribe Velez 957698572362878977
    Alvaro Uribe Velez 2564527914
    Alvaro Uribe Velez 132937980
    Alvaro Uribe Velez 190872043
    Alvaro Uribe Velez 2555241457
    Alvaro Uribe Velez 233214830
    Alvaro Uribe Velez 40959913
    Alvaro Uribe Velez 963132421821665284
    Alvaro Uribe Velez 588196690
    Alvaro Uribe Velez 3385264323
    Alvaro Uribe Velez 324696063
    Alvaro Uribe Velez 87366114
    Alvaro Uribe Velez 883104498809483265
    Alvaro Uribe Velez 851129038789902336
    Alvaro Uribe Velez 243208847
    Alvaro Uribe Velez 3163140074
    Alvaro Uribe Velez 357022781
    Alvaro Uribe Velez 75946922
    Alvaro Uribe Velez 41632736
    Alvaro Uribe Velez 261676723
    Alvaro Uribe Velez 862672225282949120
    Alvaro Uribe Velez 4505260096
    Alvaro Uribe Velez 17980523
    Alvaro Uribe Velez 380245112
    Alvaro Uribe Velez 219990061
    Alvaro Uribe Velez 246521514
    Alvaro Uribe Velez 901479291594080256
    Alvaro Uribe Velez 59179735
    Alvaro Uribe Velez 40801711
    Alvaro Uribe Velez 2485885926
    Alvaro Uribe Velez 372795695
    Alvaro Uribe Velez 2194342026
    Alvaro Uribe Velez 960545686570897408
    Alvaro Uribe Velez 34419269
    Alvaro Uribe Velez 287483682
    Alvaro Uribe Velez 281330650
    Alvaro Uribe Velez 1921489572
    Alvaro Uribe Velez 542897677
    Alvaro Uribe Velez 779521198354997248
    Alvaro Uribe Velez 151060797
    Alvaro Uribe Velez 251781876
    Alvaro Uribe Velez 2681016517
    Alvaro Uribe Velez 924056925930737664
    Alvaro Uribe Velez 142540930
    Alvaro Uribe Velez 875480728749867008
    Alvaro Uribe Velez 180596851
    Alvaro Uribe Velez 352846405
    Alvaro Uribe Velez 151259392
    Alvaro Uribe Velez 554865100
    Alvaro Uribe Velez 337355830
    Alvaro Uribe Velez 150960567
    Alvaro Uribe Velez 338797184
    Alvaro Uribe Velez 1522954405
    Alvaro Uribe Velez 1615162496
    Alvaro Uribe Velez 1861774850
    Alvaro Uribe Velez 1322830699
    Alvaro Uribe Velez 2353507109
    Alvaro Uribe Velez 814631506513629185
    Alvaro Uribe Velez 48995459
    Alvaro Uribe Velez 1113237756
    Alvaro Uribe Velez 269358055
    Alvaro Uribe Velez 4604086573
    Alvaro Uribe Velez 890752104209494016
    Alvaro Uribe Velez 128372940
    Alvaro Uribe Velez 149827409
    Alvaro Uribe Velez 212237657
    Alvaro Uribe Velez 937171166392979456
    Alvaro Uribe Velez 116222187
    Alvaro Uribe Velez 901248270453833728
    Alvaro Uribe Velez 181186389
    Alvaro Uribe Velez 65535989
    Alvaro Uribe Velez 230881728
    Alvaro Uribe Velez 772238059
    Alvaro Uribe Velez 75648469
    Alvaro Uribe Velez 72370003
    Alvaro Uribe Velez 518264505
    Alvaro Uribe Velez 1431759750
    Alvaro Uribe Velez 102277349
    Alvaro Uribe Velez 267512642
    Alvaro Uribe Velez 4895574669
    Alvaro Uribe Velez 373087886
    Alvaro Uribe Velez 2513299995
    Alvaro Uribe Velez 827189149602107392
    Alvaro Uribe Velez 2215721693
    Alvaro Uribe Velez 256452375
    Alvaro Uribe Velez 928567338684878848
    Alvaro Uribe Velez 44186827
    Alvaro Uribe Velez 905580927144914944
    Alvaro Uribe Velez 100583387
    Alvaro Uribe Velez 897488559187386368
    Alvaro Uribe Velez 244210438
    Alvaro Uribe Velez 855543350
    Alvaro Uribe Velez 191117468
    Alvaro Uribe Velez 139111958
    Alvaro Uribe Velez 804888730876211200
    Alvaro Uribe Velez 702668951055147008
    Alvaro Uribe Velez 4716729322
    Alvaro Uribe Velez 283284565
    Alvaro Uribe Velez 109620155
    Alvaro Uribe Velez 2502332532
    Alvaro Uribe Velez 141073580
    Alvaro Uribe Velez 256985617
    Alvaro Uribe Velez 3301270653
    Alvaro Uribe Velez 2473062633
    Alvaro Uribe Velez 3289306227
    Alvaro Uribe Velez 238122765
    Alvaro Uribe Velez 1344883957
    Alvaro Uribe Velez 82702071
    Alvaro Uribe Velez 2305672974
    Alvaro Uribe Velez 498929878
    Alvaro Uribe Velez 285154000
    Alvaro Uribe Velez 365214624
    Alvaro Uribe Velez 4573972401
    Alvaro Uribe Velez 252134272
    Alvaro Uribe Velez 3317785840
    Alvaro Uribe Velez 86622012
    Alvaro Uribe Velez 195069700
    Alvaro Uribe Velez 428447897
    Alvaro Uribe Velez 827858295750680576
    Alvaro Uribe Velez 538221260
    Alvaro Uribe Velez 196297226
    Alvaro Uribe Velez 235693217
    Alvaro Uribe Velez 129363124
    Alvaro Uribe Velez 631535482
    Alvaro Uribe Velez 779015543907049472
    Alvaro Uribe Velez 854003369186385920
    Alvaro Uribe Velez 1396474219
    Alvaro Uribe Velez 242146665
    Alvaro Uribe Velez 2516994598
    Alvaro Uribe Velez 378323794
    Alvaro Uribe Velez 757655760503463936
    Alvaro Uribe Velez 1269525798
    Alvaro Uribe Velez 2677878833
    Alvaro Uribe Velez 180815351
    Alvaro Uribe Velez 1643470508
    Alvaro Uribe Velez 251922978
    Alvaro Uribe Velez 116176335
    Alvaro Uribe Velez 37666984
    Alvaro Uribe Velez 298728576
    Alvaro Uribe Velez 20998647
    Alvaro Uribe Velez 759602162
    Alvaro Uribe Velez 181995906
    Alvaro Uribe Velez 79535108
    Alvaro Uribe Velez 50675591
    Alvaro Uribe Velez 1243870310
    Alvaro Uribe Velez 118563867
    Alvaro Uribe Velez 1096982192
    Alvaro Uribe Velez 581340937
    Alvaro Uribe Velez 714471755889385472
    Alvaro Uribe Velez 520653311
    Alvaro Uribe Velez 71263772
    Alvaro Uribe Velez 1020728958
    Alvaro Uribe Velez 1691434632
    Alvaro Uribe Velez 902300421871595520
    Alvaro Uribe Velez 2367963669
    Alvaro Uribe Velez 2724862150
    Alvaro Uribe Velez 78097014
    Alvaro Uribe Velez 290915381
    Alvaro Uribe Velez 913131817
    Alvaro Uribe Velez 520002412
    Alvaro Uribe Velez 378845287
    Alvaro Uribe Velez 845740051
    Alvaro Uribe Velez 80711620
    Alvaro Uribe Velez 266028254
    Alvaro Uribe Velez 144308869
    Alvaro Uribe Velez 72466209
    Alvaro Uribe Velez 715033147952480260
    Alvaro Uribe Velez 2855755535
    Alvaro Uribe Velez 4342598416
    Alvaro Uribe Velez 1458098786
    Alvaro Uribe Velez 358211026
    Alvaro Uribe Velez 150342453
    Alvaro Uribe Velez 216457140
    Alvaro Uribe Velez 263506326
    Alvaro Uribe Velez 196306441
    Alvaro Uribe Velez 7641802
    Alvaro Uribe Velez 370935720
    Alvaro Uribe Velez 138235377
    Alvaro Uribe Velez 48105688
    Alvaro Uribe Velez 702228317202751488
    Alvaro Uribe Velez 189305014
    Alvaro Uribe Velez 540894368
    Alvaro Uribe Velez 1165896991
    Alvaro Uribe Velez 1886507599
    Alvaro Uribe Velez 846662972
    Alvaro Uribe Velez 2150835234
    Alvaro Uribe Velez 1339921489
    Alvaro Uribe Velez 1692019038
    Alvaro Uribe Velez 1628773046
    Alvaro Uribe Velez 301207800
    Alvaro Uribe Velez 51725355
    Alvaro Uribe Velez 743097937350303745
    Alvaro Uribe Velez 282786285
    Alvaro Uribe Velez 132599039
    Alvaro Uribe Velez 703682063958974465
    Alvaro Uribe Velez 248894027
    Alvaro Uribe Velez 100731315
    Alvaro Uribe Velez 239663800
    Alvaro Uribe Velez 4841952010
    Alvaro Uribe Velez 259021481
    Alvaro Uribe Velez 105155628
    Alvaro Uribe Velez 267506727
    Alvaro Uribe Velez 292127417
    Alvaro Uribe Velez 628727167
    Alvaro Uribe Velez 221989598
    Alvaro Uribe Velez 136807511
    Alvaro Uribe Velez 140962682
    Alvaro Uribe Velez 98492521
    Alvaro Uribe Velez 176315005
    Alvaro Uribe Velez 885851872527036416
    Alvaro Uribe Velez 188100225
    Alvaro Uribe Velez 287176241
    Alvaro Uribe Velez 488087871
    Alvaro Uribe Velez 1380395286
    Alvaro Uribe Velez 801229285843472384
    Alvaro Uribe Velez 374017230
    Alvaro Uribe Velez 598772922
    Alvaro Uribe Velez 152353397
    Alvaro Uribe Velez 264832207
    Alvaro Uribe Velez 168413323
    Alvaro Uribe Velez 93416425
    Alvaro Uribe Velez 109770017
    Alvaro Uribe Velez 3099181942
    Alvaro Uribe Velez 840260110853246977
    Alvaro Uribe Velez 567647012
    Alvaro Uribe Velez 63190873
    Alvaro Uribe Velez 30196793
    Alvaro Uribe Velez 33718836
    Alvaro Uribe Velez 773185064616202240
    Alvaro Uribe Velez 2391834968
    Alvaro Uribe Velez 332728174
    Alvaro Uribe Velez 3376187843
    Alvaro Uribe Velez 234443909
    Alvaro Uribe Velez 1400099953
    Alvaro Uribe Velez 37287124
    Alvaro Uribe Velez 3091853545
    Alvaro Uribe Velez 18516105
    Alvaro Uribe Velez 51266095
    Alvaro Uribe Velez 3300493816
    Alvaro Uribe Velez 1976143068
    Alvaro Uribe Velez 783998828122955776
    Alvaro Uribe Velez 274165618
    Alvaro Uribe Velez 115242909
    Alvaro Uribe Velez 602687573
    Alvaro Uribe Velez 186181583
    Alvaro Uribe Velez 858010830079758336
    Alvaro Uribe Velez 2355328674
    Alvaro Uribe Velez 570506827
    Alvaro Uribe Velez 791439238948655106
    Alvaro Uribe Velez 464418324
    Alvaro Uribe Velez 167395703
    Alvaro Uribe Velez 69777546
    Alvaro Uribe Velez 290218750
    Alvaro Uribe Velez 747807250819981312
    Alvaro Uribe Velez 2430873146
    Alvaro Uribe Velez 716814829479202816
    Alvaro Uribe Velez 3245553073
    Alvaro Uribe Velez 2907961498
    Alvaro Uribe Velez 807979197704630272
    Alvaro Uribe Velez 1307634150
    Alvaro Uribe Velez 82664640
    Alvaro Uribe Velez 296269717
    Alvaro Uribe Velez 92825754
    Alvaro Uribe Velez 619954715
    Alvaro Uribe Velez 868863981053775873
    Alvaro Uribe Velez 149224097
    Alvaro Uribe Velez 756651271210369025
    Alvaro Uribe Velez 16193496
    Alvaro Uribe Velez 2576426902
    Alvaro Uribe Velez 3018879957
    Alvaro Uribe Velez 307643396
    Alvaro Uribe Velez 52544275
    Alvaro Uribe Velez 705195059885514753
    Alvaro Uribe Velez 256541943
    Alvaro Uribe Velez 1023096199
    Alvaro Uribe Velez 817777156994506752
    Alvaro Uribe Velez 725162613236207617
    Alvaro Uribe Velez 755592445333602308
    Alvaro Uribe Velez 375489514
    Alvaro Uribe Velez 1749389216
    Alvaro Uribe Velez 263717250
    Alvaro Uribe Velez 231577324
    Alvaro Uribe Velez 3233689427
    Alvaro Uribe Velez 91928506
    Alvaro Uribe Velez 307985347
    Alvaro Uribe Velez 255858620
    Alvaro Uribe Velez 1648757107
    Alvaro Uribe Velez 178378807
    Alvaro Uribe Velez 1225530379
    Alvaro Uribe Velez 1286184110
    Alvaro Uribe Velez 2529745614
    Alvaro Uribe Velez 3051551999
    Alvaro Uribe Velez 3975187749
    Alvaro Uribe Velez 757767737766805505
    Alvaro Uribe Velez 1249867920
    Alvaro Uribe Velez 2675077723
    Alvaro Uribe Velez 74964230
    Alvaro Uribe Velez 2357490871
    Alvaro Uribe Velez 240757505
    Alvaro Uribe Velez 1118004409
    Alvaro Uribe Velez 2652114734
    Alvaro Uribe Velez 1164108326
    Alvaro Uribe Velez 202003455
    Alvaro Uribe Velez 705209041950281729
    Alvaro Uribe Velez 716297985961828352
    Alvaro Uribe Velez 4063240701
    Alvaro Uribe Velez 482260296
    Alvaro Uribe Velez 842406685293588480
    Alvaro Uribe Velez 479989969
    Alvaro Uribe Velez 1481034109
    Alvaro Uribe Velez 2453836987
    Alvaro Uribe Velez 834776982059642880
    Alvaro Uribe Velez 860563925800235008
    Alvaro Uribe Velez 157003517
    Alvaro Uribe Velez 133112225
    Alvaro Uribe Velez 3399089242
    Alvaro Uribe Velez 807419737764458496
    Alvaro Uribe Velez 1069678676
    Alvaro Uribe Velez 777623518913630208
    Alvaro Uribe Velez 2275847163
    Alvaro Uribe Velez 199103902
    Alvaro Uribe Velez 1361970060
    Alvaro Uribe Velez 339398560
    Alvaro Uribe Velez 100806089
    Alvaro Uribe Velez 86654577
    Alvaro Uribe Velez 3380705986
    Alvaro Uribe Velez 1626545264
    Alvaro Uribe Velez 492234390
    Alvaro Uribe Velez 296872350
    Alvaro Uribe Velez 174040395
    Alvaro Uribe Velez 30398963
    Alvaro Uribe Velez 476784788
    Alvaro Uribe Velez 276068270
    Alvaro Uribe Velez 222421020
    Alvaro Uribe Velez 40990015
    Alvaro Uribe Velez 157214461
    Alvaro Uribe Velez 69002392
    Alvaro Uribe Velez 602869250
    Alvaro Uribe Velez 818927131883356161
    Alvaro Uribe Velez 20776147
    Alvaro Uribe Velez 588455845
    Alvaro Uribe Velez 141699787
    Alvaro Uribe Velez 803324240
    Alvaro Uribe Velez 190657623
    Alvaro Uribe Velez 896055535
    Alvaro Uribe Velez 600165145
    Alvaro Uribe Velez 213820280
    Alvaro Uribe Velez 432734103
    Alvaro Uribe Velez 408166095
    Alvaro Uribe Velez 1317247278
    Alvaro Uribe Velez 766296284013658113
    Alvaro Uribe Velez 720480098
    Alvaro Uribe Velez 583069323
    Alvaro Uribe Velez 612710896
    Alvaro Uribe Velez 934346580
    Alvaro Uribe Velez 152821970
    Alvaro Uribe Velez 3075028654
    Alvaro Uribe Velez 48150248
    Alvaro Uribe Velez 2371011068
    Alvaro Uribe Velez 510423261
    Alvaro Uribe Velez 158256932
    Alvaro Uribe Velez 848971863741145088
    Alvaro Uribe Velez 2400260346
    Alvaro Uribe Velez 1916241414
    Alvaro Uribe Velez 2713719226
    Alvaro Uribe Velez 3246417142
    Alvaro Uribe Velez 168520768
    Alvaro Uribe Velez 74538511
    Alvaro Uribe Velez 373490841
    Alvaro Uribe Velez 2655709058
    Alvaro Uribe Velez 2510599518
    Alvaro Uribe Velez 425921588
    Alvaro Uribe Velez 412764716
    Alvaro Uribe Velez 2812597937
    Alvaro Uribe Velez 53512326
    Alvaro Uribe Velez 147598539
    Alvaro Uribe Velez 429400896
    Alvaro Uribe Velez 1142649979
    Alvaro Uribe Velez 228175939
    Alvaro Uribe Velez 431929131
    Alvaro Uribe Velez 316646867
    Alvaro Uribe Velez 1628800273
    Alvaro Uribe Velez 1653853434
    Alvaro Uribe Velez 772353336
    Alvaro Uribe Velez 332916514
    Alvaro Uribe Velez 801562070751858690
    Alvaro Uribe Velez 514524361
    Alvaro Uribe Velez 142314442
    Alvaro Uribe Velez 947912917
    Alvaro Uribe Velez 108327741
    Alvaro Uribe Velez 1400202182
    Alvaro Uribe Velez 317318940
    Alvaro Uribe Velez 829850897865961472
    Alvaro Uribe Velez 133892839
    Alvaro Uribe Velez 490433123
    Alvaro Uribe Velez 246261681
    Alvaro Uribe Velez 79868273
    Alvaro Uribe Velez 3067975259
    Alvaro Uribe Velez 425633068
    Alvaro Uribe Velez 747421072232841217
    Alvaro Uribe Velez 24776620
    Alvaro Uribe Velez 115724792
    Alvaro Uribe Velez 128592955
    Alvaro Uribe Velez 65728343
    Alvaro Uribe Velez 878501298
    Alvaro Uribe Velez 314889375
    Alvaro Uribe Velez 1918726627
    Alvaro Uribe Velez 2723763371
    Alvaro Uribe Velez 160592592
    Alvaro Uribe Velez 774375415460790273
    Alvaro Uribe Velez 837834558473142272
    Alvaro Uribe Velez 334144450
    Alvaro Uribe Velez 887200122
    Alvaro Uribe Velez 324065671
    Alvaro Uribe Velez 827669533359869952
    Alvaro Uribe Velez 838433020113731585
    Alvaro Uribe Velez 480874631
    Alvaro Uribe Velez 141998493
    Alvaro Uribe Velez 1010194058
    Alvaro Uribe Velez 522627214
    Alvaro Uribe Velez 309470658
    Alvaro Uribe Velez 818910970567344128
    Alvaro Uribe Velez 822215673812119553
    Alvaro Uribe Velez 57664761
    Alvaro Uribe Velez 257332880
    Alvaro Uribe Velez 95017639
    Alvaro Uribe Velez 60957050
    Alvaro Uribe Velez 117522402
    Alvaro Uribe Velez 270669707
    Alvaro Uribe Velez 797918996788051968
    Alvaro Uribe Velez 1327869115
    Alvaro Uribe Velez 700749309667487744
    Alvaro Uribe Velez 59981052
    Alvaro Uribe Velez 102700680
    Alvaro Uribe Velez 1401091160
    Alvaro Uribe Velez 818917966821675009
    Alvaro Uribe Velez 69383056
    Alvaro Uribe Velez 16002085
    Alvaro Uribe Velez 314024921
    Alvaro Uribe Velez 620690358
    Alvaro Uribe Velez 1976116621
    Alvaro Uribe Velez 185173076
    Alvaro Uribe Velez 171273754
    Alvaro Uribe Velez 805781730452000768
    Alvaro Uribe Velez 800889069769261056
    Alvaro Uribe Velez 163750062
    Alvaro Uribe Velez 58977300
    Alvaro Uribe Velez 30861738
    Alvaro Uribe Velez 275669169
    Alvaro Uribe Velez 314907522
    Alvaro Uribe Velez 2953203339
    Alvaro Uribe Velez 807950937423802368
    Alvaro Uribe Velez 86129676
    Alvaro Uribe Velez 2780672434
    Alvaro Uribe Velez 19394188
    Alvaro Uribe Velez 47514423
    Alvaro Uribe Velez 190334558
    Alvaro Uribe Velez 303168830
    Alvaro Uribe Velez 101351447
    Alvaro Uribe Velez 2239282612
    Alvaro Uribe Velez 178923222
    Alvaro Uribe Velez 37758638
    Alvaro Uribe Velez 2418146478
    Alvaro Uribe Velez 4898512486
    Alvaro Uribe Velez 287690539
    Alvaro Uribe Velez 95494483
    Alvaro Uribe Velez 244655353
    Alvaro Uribe Velez 282286404
    Alvaro Uribe Velez 196806742
    Alvaro Uribe Velez 24516380
    Alvaro Uribe Velez 257599992
    Alvaro Uribe Velez 564226109
    Alvaro Uribe Velez 3017515569
    Alvaro Uribe Velez 368705981
    Alvaro Uribe Velez 764071236322426880
    Alvaro Uribe Velez 41139989
    Alvaro Uribe Velez 221603141
    Alvaro Uribe Velez 48036557
    Alvaro Uribe Velez 2515991653
    Alvaro Uribe Velez 136773524
    Alvaro Uribe Velez 73245966
    Alvaro Uribe Velez 20733972
    Alvaro Uribe Velez 25484126
    Alvaro Uribe Velez 3147972826
    Alvaro Uribe Velez 15416505
    Alvaro Uribe Velez 3559793237
    Alvaro Uribe Velez 2360328709
    Alvaro Uribe Velez 594982962
    Alvaro Uribe Velez 4100945003
    Alvaro Uribe Velez 241255425
    Alvaro Uribe Velez 36378198
    Alvaro Uribe Velez 708048865216299009
    Alvaro Uribe Velez 2584136940
    Alvaro Uribe Velez 2395075182
    Alvaro Uribe Velez 1367531
    Alvaro Uribe Velez 772826147201712128
    Alvaro Uribe Velez 771382226869227520
    Alvaro Uribe Velez 3016241603
    Alvaro Uribe Velez 521382236
    Alvaro Uribe Velez 2873771193
    Alvaro Uribe Velez 46881592
    Alvaro Uribe Velez 904828398
    Alvaro Uribe Velez 396042912
    Alvaro Uribe Velez 378307144
    Alvaro Uribe Velez 176852177
    Alvaro Uribe Velez 4107908716
    Alvaro Uribe Velez 134102099
    Alvaro Uribe Velez 128010770
    Alvaro Uribe Velez 3086735879
    Alvaro Uribe Velez 132885483
    Alvaro Uribe Velez 580127908
    Alvaro Uribe Velez 54547101
    Alvaro Uribe Velez 114476962
    Alvaro Uribe Velez 1463665614
    Alvaro Uribe Velez 1279112347
    Alvaro Uribe Velez 1278130146
    Alvaro Uribe Velez 242730842
    Alvaro Uribe Velez 741373360429502464
    Alvaro Uribe Velez 135543313
    Alvaro Uribe Velez 179529440
    Alvaro Uribe Velez 99956296
    Alvaro Uribe Velez 171955994
    Alvaro Uribe Velez 4900146051
    Alvaro Uribe Velez 776559874251579392
    Alvaro Uribe Velez 554785837
    Alvaro Uribe Velez 109421450
    Alvaro Uribe Velez 1920961778
    Alvaro Uribe Velez 285032829
    Alvaro Uribe Velez 757700121618296833
    Alvaro Uribe Velez 723346694
    Alvaro Uribe Velez 224310417
    Alvaro Uribe Velez 266240697
    Alvaro Uribe Velez 42131034
    Alvaro Uribe Velez 268322810
    Alvaro Uribe Velez 25411140
    Alvaro Uribe Velez 753768600448688128
    Alvaro Uribe Velez 211990143
    Alvaro Uribe Velez 532293702
    Alvaro Uribe Velez 2874285407
    Alvaro Uribe Velez 712954729
    Alvaro Uribe Velez 2188951002
    Alvaro Uribe Velez 18457447
    Alvaro Uribe Velez 139854980
    Alvaro Uribe Velez 147204319
    Alvaro Uribe Velez 720582764
    Alvaro Uribe Velez 3397488010
    Alvaro Uribe Velez 150248933
    Alvaro Uribe Velez 143132603
    Alvaro Uribe Velez 153044706
    Alvaro Uribe Velez 2481037866
    Alvaro Uribe Velez 1596053635
    Alvaro Uribe Velez 752192886385639424
    Alvaro Uribe Velez 69350928
    Alvaro Uribe Velez 2610502687
    Alvaro Uribe Velez 976692566
    Alvaro Uribe Velez 2352530960
    Alvaro Uribe Velez 301723793
    Alvaro Uribe Velez 472957301
    Alvaro Uribe Velez 4063952721
    Alvaro Uribe Velez 2453642179
    Alvaro Uribe Velez 1463506830
    Alvaro Uribe Velez 1180020318
    Alvaro Uribe Velez 4767302069
    Alvaro Uribe Velez 1249261340
    Alvaro Uribe Velez 1954440583
    Alvaro Uribe Velez 3041787885
    Alvaro Uribe Velez 141361271
    Alvaro Uribe Velez 229954866
    Alvaro Uribe Velez 282738081
    Alvaro Uribe Velez 93991568
    Alvaro Uribe Velez 858626461
    Alvaro Uribe Velez 264553283
    Alvaro Uribe Velez 143291831
    Alvaro Uribe Velez 856487352
    Alvaro Uribe Velez 1544111030
    Alvaro Uribe Velez 1403871768
    Alvaro Uribe Velez 1557114475
    Alvaro Uribe Velez 297503036
    Alvaro Uribe Velez 306487754
    Alvaro Uribe Velez 152692702
    Alvaro Uribe Velez 50678357
    Alvaro Uribe Velez 1249546064
    Alvaro Uribe Velez 159655293
    Alvaro Uribe Velez 3290563589
    Alvaro Uribe Velez 2675543582
    Alvaro Uribe Velez 211679970
    Alvaro Uribe Velez 471589492
    Alvaro Uribe Velez 2773566085
    Alvaro Uribe Velez 746831847330545664
    Alvaro Uribe Velez 268980314
    Alvaro Uribe Velez 131852038
    Alvaro Uribe Velez 325856294
    Alvaro Uribe Velez 139222180
    Alvaro Uribe Velez 738128293
    Alvaro Uribe Velez 18265605
    Alvaro Uribe Velez 194140375
    Alvaro Uribe Velez 2808112943
    Alvaro Uribe Velez 220004760
    Alvaro Uribe Velez 140954083
    Alvaro Uribe Velez 154702186
    Alvaro Uribe Velez 141258984
    Alvaro Uribe Velez 34996429
    Alvaro Uribe Velez 2361800418
    Alvaro Uribe Velez 138190882
    Alvaro Uribe Velez 2765865639
    Alvaro Uribe Velez 2990160447
    Alvaro Uribe Velez 52588157
    Alvaro Uribe Velez 231829435
    Alvaro Uribe Velez 109881411
    Alvaro Uribe Velez 15439770
    Alvaro Uribe Velez 1301761278
    Alvaro Uribe Velez 198659088
    Alvaro Uribe Velez 33553702
    Alvaro Uribe Velez 20980846
    Alvaro Uribe Velez 790045632
    Alvaro Uribe Velez 164077677
    Alvaro Uribe Velez 144515942
    Alvaro Uribe Velez 3593042535
    Alvaro Uribe Velez 2674249872
    Alvaro Uribe Velez 281942420
    Alvaro Uribe Velez 61731614
    Alvaro Uribe Velez 533577402
    Alvaro Uribe Velez 636504935
    Alvaro Uribe Velez 14119342
    Alvaro Uribe Velez 3246888214
    Alvaro Uribe Velez 300876534
    Alvaro Uribe Velez 4922906307
    Alvaro Uribe Velez 54143577
    Alvaro Uribe Velez 152391159
    Alvaro Uribe Velez 19236297
    Alvaro Uribe Velez 139443008
    Alvaro Uribe Velez 28732665
    Alvaro Uribe Velez 731712850415263744
    Alvaro Uribe Velez 2388386342
    Alvaro Uribe Velez 2237381659
    Alvaro Uribe Velez 3053804763
    Alvaro Uribe Velez 256747696
    Alvaro Uribe Velez 229495894
    Alvaro Uribe Velez 62530556
    Alvaro Uribe Velez 169805100
    Alvaro Uribe Velez 61223967
    Alvaro Uribe Velez 365857781
    Alvaro Uribe Velez 20910995
    Alvaro Uribe Velez 803054006
    Alvaro Uribe Velez 3193116503
    Alvaro Uribe Velez 1883920812
    Alvaro Uribe Velez 3075638625
    Alvaro Uribe Velez 723637359972106241
    Alvaro Uribe Velez 2423412582
    Alvaro Uribe Velez 916319970
    Alvaro Uribe Velez 586783065
    Alvaro Uribe Velez 32128679
    Alvaro Uribe Velez 1228312916
    Alvaro Uribe Velez 565759567
    Alvaro Uribe Velez 2546046459
    Alvaro Uribe Velez 25490757
    Alvaro Uribe Velez 337858162
    Alvaro Uribe Velez 14594813
    Alvaro Uribe Velez 25323002
    Alvaro Uribe Velez 1138151251
    Alvaro Uribe Velez 93923633
    Alvaro Uribe Velez 77320831
    Alvaro Uribe Velez 3138789113
    Alvaro Uribe Velez 718531595611807744
    Alvaro Uribe Velez 64398702
    Alvaro Uribe Velez 104613681
    Alvaro Uribe Velez 35883193
    Alvaro Uribe Velez 4339548382
    Alvaro Uribe Velez 103550181
    Alvaro Uribe Velez 21637092
    Alvaro Uribe Velez 120805318
    Alvaro Uribe Velez 173178053
    Alvaro Uribe Velez 1389879272
    Alvaro Uribe Velez 33372315
    Alvaro Uribe Velez 115164204
    Alvaro Uribe Velez 60083391
    Alvaro Uribe Velez 80047141
    Alvaro Uribe Velez 717865381772320768
    Alvaro Uribe Velez 155428489
    Alvaro Uribe Velez 1677007038
    Alvaro Uribe Velez 1425639174
    Alvaro Uribe Velez 85840608
    Alvaro Uribe Velez 2760935819
    Alvaro Uribe Velez 2742652587
    Alvaro Uribe Velez 1671358760
    Alvaro Uribe Velez 247487404
    Alvaro Uribe Velez 1452886604
    Alvaro Uribe Velez 87068960
    Alvaro Uribe Velez 1401041252
    Alvaro Uribe Velez 2727746361
    Alvaro Uribe Velez 6529402
    Alvaro Uribe Velez 314817584
    Alvaro Uribe Velez 31448994
    Alvaro Uribe Velez 1869817063
    Alvaro Uribe Velez 173588099
    Alvaro Uribe Velez 135662645
    Alvaro Uribe Velez 344750737
    Alvaro Uribe Velez 218608967
    Alvaro Uribe Velez 118731088
    Alvaro Uribe Velez 80998433
    Alvaro Uribe Velez 1582987716
    Alvaro Uribe Velez 512399291
    Alvaro Uribe Velez 204033649
    Alvaro Uribe Velez 594021942
    Alvaro Uribe Velez 1115440213
    Alvaro Uribe Velez 369490361
    Alvaro Uribe Velez 2290560281
    Alvaro Uribe Velez 579989617
    Alvaro Uribe Velez 3149829387
    Alvaro Uribe Velez 1021362511
    Alvaro Uribe Velez 463405914
    Alvaro Uribe Velez 2437545426
    Alvaro Uribe Velez 23022687
    Alvaro Uribe Velez 149679788
    Alvaro Uribe Velez 25073877
    Alvaro Uribe Velez 156041343
    Alvaro Uribe Velez 40378778
    Alvaro Uribe Velez 465089702
    Alvaro Uribe Velez 706924229271412736
    Alvaro Uribe Velez 2836421
    Alvaro Uribe Velez 253207105
    Alvaro Uribe Velez 15007149
    Alvaro Uribe Velez 37094727
    Alvaro Uribe Velez 2196442651
    Alvaro Uribe Velez 209134275
    Alvaro Uribe Velez 4573732999
    Alvaro Uribe Velez 632417584
    Alvaro Uribe Velez 580993736
    Alvaro Uribe Velez 84195118
    Alvaro Uribe Velez 132043337
    Alvaro Uribe Velez 225151668
    Alvaro Uribe Velez 137903102
    Alvaro Uribe Velez 97100000
    Alvaro Uribe Velez 1628602776
    Alvaro Uribe Velez 42832810
    Alvaro Uribe Velez 437854084
    Alvaro Uribe Velez 34140316
    Alvaro Uribe Velez 176438967
    Alvaro Uribe Velez 2228974487
    Alvaro Uribe Velez 612551899
    Alvaro Uribe Velez 231721538
    Alvaro Uribe Velez 74363835
    Alvaro Uribe Velez 407308886
    Alvaro Uribe Velez 128914162
    Alvaro Uribe Velez 137002926
    Alvaro Uribe Velez 2802545808
    Alvaro Uribe Velez 2508510824
    Alvaro Uribe Velez 159950603
    Alvaro Uribe Velez 1277979181
    Alvaro Uribe Velez 104237736
    Alvaro Uribe Velez 2792805879
    Alvaro Uribe Velez 5120691
    Alvaro Uribe Velez 2778548219
    Alvaro Uribe Velez 89485410
    Alvaro Uribe Velez 335307210
    Alvaro Uribe Velez 1216071709
    Alvaro Uribe Velez 1676560855
    Alvaro Uribe Velez 2870759343
    Alvaro Uribe Velez 3295956454
    Alvaro Uribe Velez 15745368
    Alvaro Uribe Velez 4430291429
    Alvaro Uribe Velez 2159260049
    Alvaro Uribe Velez 14119371
    Alvaro Uribe Velez 210335385
    Alvaro Uribe Velez 41169468
    Alvaro Uribe Velez 177019825
    Alvaro Uribe Velez 274029951
    Alvaro Uribe Velez 70594101
    Alvaro Uribe Velez 253582640
    Alvaro Uribe Velez 134615013
    Alvaro Uribe Velez 592302733
    Alvaro Uribe Velez 1183887576
    Alvaro Uribe Velez 109040582
    Alvaro Uribe Velez 33989170
    Alvaro Uribe Velez 8105922
    Alvaro Uribe Velez 41634587
    Alvaro Uribe Velez 796590756
    Alvaro Uribe Velez 17895820
    Alvaro Uribe Velez 2371169329
    Alvaro Uribe Velez 1323450421
    Alvaro Uribe Velez 58694945
    Alvaro Uribe Velez 728814980
    Alvaro Uribe Velez 183338213
    Alvaro Uribe Velez 136354790
    Alvaro Uribe Velez 114772821
    Alvaro Uribe Velez 65460693
    Alvaro Uribe Velez 305702960
    Alvaro Uribe Velez 253387694
    Alvaro Uribe Velez 1096832935
    Alvaro Uribe Velez 71914822
    Alvaro Uribe Velez 221768855
    Alvaro Uribe Velez 3290670695
    Alvaro Uribe Velez 41292729
    Alvaro Uribe Velez 3436126677
    Alvaro Uribe Velez 290327822
    Alvaro Uribe Velez 125705907
    Alvaro Uribe Velez 135885534
    Alvaro Uribe Velez 2777910755
    Alvaro Uribe Velez 127409450
    Alvaro Uribe Velez 156650093
    Alvaro Uribe Velez 420691194
    Alvaro Uribe Velez 1270407343
    Alvaro Uribe Velez 1961023128
    Alvaro Uribe Velez 2423058260
    Alvaro Uribe Velez 3324187337
    Alvaro Uribe Velez 847387604
    Alvaro Uribe Velez 2445809510
    Alvaro Uribe Velez 14800270
    Alvaro Uribe Velez 787894110
    Alvaro Uribe Velez 1048262227
    Alvaro Uribe Velez 377553700
    Alvaro Uribe Velez 1619265078
    Alvaro Uribe Velez 248755345
    Alvaro Uribe Velez 3433086249
    Alvaro Uribe Velez 3357762364
    Alvaro Uribe Velez 299827783
    Alvaro Uribe Velez 266712590
    Alvaro Uribe Velez 2568043866
    Alvaro Uribe Velez 131183505
    Alvaro Uribe Velez 206407402
    Alvaro Uribe Velez 1879791901
    Alvaro Uribe Velez 76664119
    Alvaro Uribe Velez 323178068
    Alvaro Uribe Velez 2340720397
    Alvaro Uribe Velez 182959884
    Alvaro Uribe Velez 486246305
    Alvaro Uribe Velez 3167452769
    Alvaro Uribe Velez 358887972
    Alvaro Uribe Velez 1597352947
    Alvaro Uribe Velez 133769083
    Alvaro Uribe Velez 113486205
    Alvaro Uribe Velez 132968680
    Alvaro Uribe Velez 145741832
    Alvaro Uribe Velez 167535742
    Alvaro Uribe Velez 3290218899
    Alvaro Uribe Velez 974526674
    Alvaro Uribe Velez 2951995276
    Alvaro Uribe Velez 951643866
    Alvaro Uribe Velez 1056333480
    Alvaro Uribe Velez 152341106
    Alvaro Uribe Velez 478034854
    Alvaro Uribe Velez 586861205
    Alvaro Uribe Velez 858952590
    Alvaro Uribe Velez 57952293
    Alvaro Uribe Velez 619334096
    Alvaro Uribe Velez 871293914
    Alvaro Uribe Velez 101314283
    Alvaro Uribe Velez 170883038
    Alvaro Uribe Velez 593454273
    Alvaro Uribe Velez 382202431
    Alvaro Uribe Velez 187282614
    Alvaro Uribe Velez 627485696
    Alvaro Uribe Velez 422382623
    Alvaro Uribe Velez 157684872
    Alvaro Uribe Velez 555574701
    Alvaro Uribe Velez 1663775444
    Alvaro Uribe Velez 142017064
    Alvaro Uribe Velez 102759477
    Alvaro Uribe Velez 29110681
    Alvaro Uribe Velez 2999108097
    Alvaro Uribe Velez 215324848
    Alvaro Uribe Velez 33246493
    Alvaro Uribe Velez 252279244
    Alvaro Uribe Velez 1150836289
    Alvaro Uribe Velez 3155253641
    Alvaro Uribe Velez 129807575
    Alvaro Uribe Velez 3127555847
    Alvaro Uribe Velez 3246537749
    Alvaro Uribe Velez 39693346
    Alvaro Uribe Velez 2171597572
    Alvaro Uribe Velez 860562876
    Alvaro Uribe Velez 146472401
    Alvaro Uribe Velez 51360342
    Alvaro Uribe Velez 565482190
    Alvaro Uribe Velez 574450141
    Alvaro Uribe Velez 2785518297
    Alvaro Uribe Velez 307865186
    Alvaro Uribe Velez 3179687513
    Alvaro Uribe Velez 286208934
    Alvaro Uribe Velez 193460988
    Alvaro Uribe Velez 69721946
    Alvaro Uribe Velez 2150131172
    Alvaro Uribe Velez 2937120827
    Alvaro Uribe Velez 2511472471
    Alvaro Uribe Velez 74459830
    Alvaro Uribe Velez 152056202
    Alvaro Uribe Velez 492464338
    Alvaro Uribe Velez 85125331
    Alvaro Uribe Velez 1626382375
    Alvaro Uribe Velez 224315712
    Alvaro Uribe Velez 239938002
    Alvaro Uribe Velez 1614287323
    Alvaro Uribe Velez 141230982
    Alvaro Uribe Velez 202486418
    Alvaro Uribe Velez 535707261
    Alvaro Uribe Velez 142422264
    Alvaro Uribe Velez 2782197831
    Alvaro Uribe Velez 501199483
    Alvaro Uribe Velez 278266581
    Alvaro Uribe Velez 105601172
    Alvaro Uribe Velez 59164325
    Alvaro Uribe Velez 587073354
    Alvaro Uribe Velez 285444891
    Alvaro Uribe Velez 229640417
    Alvaro Uribe Velez 350411337
    Alvaro Uribe Velez 2601812699
    Alvaro Uribe Velez 48311642
    Alvaro Uribe Velez 2546780857
    Alvaro Uribe Velez 80417990
    Alvaro Uribe Velez 1292753798
    Alvaro Uribe Velez 114933382
    Alvaro Uribe Velez 25347345
    Alvaro Uribe Velez 257004870
    Alvaro Uribe Velez 248796243
    Alvaro Uribe Velez 347608751
    Alvaro Uribe Velez 1528141772
    Alvaro Uribe Velez 82993613
    Alvaro Uribe Velez 514520753
    Alvaro Uribe Velez 299197051
    Alvaro Uribe Velez 147334355
    Alvaro Uribe Velez 448165069
    Alvaro Uribe Velez 33344104
    Alvaro Uribe Velez 215846002
    Alvaro Uribe Velez 423551710
    Alvaro Uribe Velez 3075563285
    Alvaro Uribe Velez 2507758897
    Alvaro Uribe Velez 601163523
    Alvaro Uribe Velez 19891116
    Alvaro Uribe Velez 164011139
    Alvaro Uribe Velez 2163790907
    Alvaro Uribe Velez 747254647
    Alvaro Uribe Velez 589450215
    Alvaro Uribe Velez 156271750
    Alvaro Uribe Velez 1876032078
    Alvaro Uribe Velez 989868385
    Alvaro Uribe Velez 80380326
    Alvaro Uribe Velez 40282700
    Alvaro Uribe Velez 2311130433
    Alvaro Uribe Velez 424303769
    Alvaro Uribe Velez 58987500
    Alvaro Uribe Velez 138923374
    Alvaro Uribe Velez 67755133
    Alvaro Uribe Velez 255549819
    Alvaro Uribe Velez 93220775
    Alvaro Uribe Velez 2991797616
    Alvaro Uribe Velez 199811461
    Alvaro Uribe Velez 1238774719
    Alvaro Uribe Velez 1117317140
    Alvaro Uribe Velez 3030251068
    Alvaro Uribe Velez 131599970
    Alvaro Uribe Velez 14063051
    Alvaro Uribe Velez 883324645
    Alvaro Uribe Velez 207073606
    Alvaro Uribe Velez 172067666
    Alvaro Uribe Velez 169199015
    Alvaro Uribe Velez 54372808
    Alvaro Uribe Velez 867495655
    Alvaro Uribe Velez 45836317
    Alvaro Uribe Velez 49638313
    Alvaro Uribe Velez 172903092
    Alvaro Uribe Velez 50435655
    Alvaro Uribe Velez 257734070
    Alvaro Uribe Velez 80574531
    Alvaro Uribe Velez 190913243
    Alvaro Uribe Velez 141432041
    Alvaro Uribe Velez 50812392
    Alvaro Uribe Velez 533085085
    Alvaro Uribe Velez 627673190
    Alvaro Uribe Velez 333534411
    Alvaro Uribe Velez 740336334
    Alvaro Uribe Velez 14872237
    Alvaro Uribe Velez 1337215440
    Alvaro Uribe Velez 165911032
    Alvaro Uribe Velez 141423259
    Alvaro Uribe Velez 147589125
    Alvaro Uribe Velez 2940026403
    Alvaro Uribe Velez 745314768
    Alvaro Uribe Velez 626743228
    Alvaro Uribe Velez 775071518
    Alvaro Uribe Velez 2402286084
    Alvaro Uribe Velez 1579031275
    Alvaro Uribe Velez 2905215136
    Alvaro Uribe Velez 258604558
    Alvaro Uribe Velez 557962740
    Alvaro Uribe Velez 2842415200
    Alvaro Uribe Velez 145025295
    Alvaro Uribe Velez 878332500
    Alvaro Uribe Velez 134186192
    Alvaro Uribe Velez 791545164
    Alvaro Uribe Velez 1452819121
    Alvaro Uribe Velez 2682917247
    Alvaro Uribe Velez 858800562
    Alvaro Uribe Velez 343447873
    Alvaro Uribe Velez 6467332
    Alvaro Uribe Velez 14224719
    Alvaro Uribe Velez 76223028
    Alvaro Uribe Velez 178612341
    Alvaro Uribe Velez 234161597
    Alvaro Uribe Velez 231307908
    Alvaro Uribe Velez 397729587
    Alvaro Uribe Velez 2479143242
    Alvaro Uribe Velez 332339142
    Alvaro Uribe Velez 2330849761
    Alvaro Uribe Velez 851108442
    Alvaro Uribe Velez 297426828
    Alvaro Uribe Velez 243931828
    Alvaro Uribe Velez 157882693
    Alvaro Uribe Velez 241228325
    Alvaro Uribe Velez 1230605077
    Alvaro Uribe Velez 208308070
    Alvaro Uribe Velez 159575083
    Alvaro Uribe Velez 1027410314
    Alvaro Uribe Velez 42074231
    Alvaro Uribe Velez 151745250
    Alvaro Uribe Velez 309374492
    Alvaro Uribe Velez 105082141
    Alvaro Uribe Velez 98702606
    Alvaro Uribe Velez 368884029
    Alvaro Uribe Velez 16676396
    Alvaro Uribe Velez 24900072
    Alvaro Uribe Velez 117185027
    Alvaro Uribe Velez 1516609855
    Alvaro Uribe Velez 192538987
    Alvaro Uribe Velez 2774054927
    Alvaro Uribe Velez 2530496706
    Alvaro Uribe Velez 147750051
    Alvaro Uribe Velez 58559693
    Alvaro Uribe Velez 60998884
    Alvaro Uribe Velez 1206008396
    Alvaro Uribe Velez 1118254976
    Alvaro Uribe Velez 201770926
    Alvaro Uribe Velez 486750544
    Alvaro Uribe Velez 71560212
    Alvaro Uribe Velez 482591300
    Alvaro Uribe Velez 533573263
    Alvaro Uribe Velez 826205455
    Alvaro Uribe Velez 943843464
    Alvaro Uribe Velez 308609534
    Alvaro Uribe Velez 113097830
    Alvaro Uribe Velez 318106249
    Alvaro Uribe Velez 118425472
    Alvaro Uribe Velez 243765505
    Alvaro Uribe Velez 78944377
    Alvaro Uribe Velez 51241574
    Alvaro Uribe Velez 77331836
    Alvaro Uribe Velez 145459615
    Alvaro Uribe Velez 2364388706
    Alvaro Uribe Velez 62917505
    Alvaro Uribe Velez 2833178631
    Alvaro Uribe Velez 206175400
    Alvaro Uribe Velez 1618800769
    Alvaro Uribe Velez 189861728
    Alvaro Uribe Velez 257209992
    Alvaro Uribe Velez 40098182
    Alvaro Uribe Velez 21849140
    Alvaro Uribe Velez 2690788812
    Alvaro Uribe Velez 1368672085
    Alvaro Uribe Velez 321476586
    Alvaro Uribe Velez 1623349022
    Alvaro Uribe Velez 228498424
    Alvaro Uribe Velez 631822419
    Alvaro Uribe Velez 716386614
    Alvaro Uribe Velez 1965156224
    Alvaro Uribe Velez 2709686844
    Alvaro Uribe Velez 114469124
    Alvaro Uribe Velez 165810422
    Alvaro Uribe Velez 48747680
    Alvaro Uribe Velez 13623532
    Alvaro Uribe Velez 279234418
    Alvaro Uribe Velez 253315622
    Alvaro Uribe Velez 264056743
    Alvaro Uribe Velez 420592061
    Alvaro Uribe Velez 114707574
    Alvaro Uribe Velez 149689394
    Alvaro Uribe Velez 142726725
    Alvaro Uribe Velez 29146092
    Alvaro Uribe Velez 1000699344
    Alvaro Uribe Velez 1447164050
    Alvaro Uribe Velez 397544937
    Alvaro Uribe Velez 227807969
    Alvaro Uribe Velez 510752785
    Alvaro Uribe Velez 2821455029
    Alvaro Uribe Velez 121256004
    Alvaro Uribe Velez 476102102
    Alvaro Uribe Velez 277206820
    Alvaro Uribe Velez 855803366
    Alvaro Uribe Velez 409654033
    Alvaro Uribe Velez 173950896
    Alvaro Uribe Velez 149630149
    Alvaro Uribe Velez 2239273318
    Alvaro Uribe Velez 628606375
    Alvaro Uribe Velez 578726904
    Alvaro Uribe Velez 2410543611
    Alvaro Uribe Velez 1236638994
    Alvaro Uribe Velez 41814169
    Alvaro Uribe Velez 200267797
    Alvaro Uribe Velez 2235050528
    Alvaro Uribe Velez 2411541594
    Alvaro Uribe Velez 25330246
    Alvaro Uribe Velez 200734153
    Alvaro Uribe Velez 164949319
    Alvaro Uribe Velez 1903940562
    Alvaro Uribe Velez 329463917
    Alvaro Uribe Velez 37748192
    Alvaro Uribe Velez 212094747
    Alvaro Uribe Velez 901737541
    Alvaro Uribe Velez 936458046
    Alvaro Uribe Velez 240422474
    Alvaro Uribe Velez 60619634
    Alvaro Uribe Velez 92537787
    Alvaro Uribe Velez 609220520
    Alvaro Uribe Velez 1378168597
    Alvaro Uribe Velez 1469852694
    Alvaro Uribe Velez 38386328
    Alvaro Uribe Velez 301630501
    Alvaro Uribe Velez 2260207265
    Alvaro Uribe Velez 305572953
    Alvaro Uribe Velez 77878992
    Alvaro Uribe Velez 214114587
    Alvaro Uribe Velez 3222731
    Alvaro Uribe Velez 167391967
    Alvaro Uribe Velez 197458055
    Alvaro Uribe Velez 483200237
    Alvaro Uribe Velez 86145232
    Alvaro Uribe Velez 2185421023
    Alvaro Uribe Velez 180505807
    Alvaro Uribe Velez 97247298
    Alvaro Uribe Velez 285143935
    Alvaro Uribe Velez 158022452
    Alvaro Uribe Velez 482353674
    Alvaro Uribe Velez 406780078
    Alvaro Uribe Velez 222456405
    Alvaro Uribe Velez 192264657
    Alvaro Uribe Velez 1220359982
    Alvaro Uribe Velez 730403330
    Alvaro Uribe Velez 2169662044
    Alvaro Uribe Velez 807095
    Alvaro Uribe Velez 502343604
    Alvaro Uribe Velez 313420780
    Alvaro Uribe Velez 91390383
    Alvaro Uribe Velez 190902087
    Alvaro Uribe Velez 285352983
    Alvaro Uribe Velez 1886792071
    Alvaro Uribe Velez 143250016
    Alvaro Uribe Velez 2298232075
    Alvaro Uribe Velez 142306651
    Alvaro Uribe Velez 67360960
    Alvaro Uribe Velez 349249483
    Alvaro Uribe Velez 1667809860
    Alvaro Uribe Velez 576630107
    Alvaro Uribe Velez 553132197
    Alvaro Uribe Velez 193532880
    Alvaro Uribe Velez 625191280
    Alvaro Uribe Velez 83517273
    Alvaro Uribe Velez 476011253
    Alvaro Uribe Velez 55558616
    Alvaro Uribe Velez 1384653704
    Alvaro Uribe Velez 87946729
    Alvaro Uribe Velez 2687968392
    Alvaro Uribe Velez 315377387
    Alvaro Uribe Velez 300390462
    Alvaro Uribe Velez 155456120
    Alvaro Uribe Velez 264308721
    Alvaro Uribe Velez 2259167089
    Alvaro Uribe Velez 1390437692
    Alvaro Uribe Velez 346303806
    Alvaro Uribe Velez 2326136200
    Alvaro Uribe Velez 145408565
    Alvaro Uribe Velez 54370832
    Alvaro Uribe Velez 1170750632
    Alvaro Uribe Velez 3108351
    Alvaro Uribe Velez 151683919
    Alvaro Uribe Velez 219750815
    Alvaro Uribe Velez 111491345
    Alvaro Uribe Velez 240277625
    Alvaro Uribe Velez 137187144
    Alvaro Uribe Velez 263803071
    Alvaro Uribe Velez 592168280
    Alvaro Uribe Velez 122446921
    Alvaro Uribe Velez 34641036
    Alvaro Uribe Velez 113451138
    Alvaro Uribe Velez 136426609
    Alvaro Uribe Velez 2584142433
    Alvaro Uribe Velez 47131926
    Alvaro Uribe Velez 141039072
    Alvaro Uribe Velez 50494032
    Alvaro Uribe Velez 152394247
    Alvaro Uribe Velez 122493244
    Alvaro Uribe Velez 192976204
    Alvaro Uribe Velez 1915063518
    Alvaro Uribe Velez 220230069
    Alvaro Uribe Velez 108541384
    Alvaro Uribe Velez 2610688068
    Alvaro Uribe Velez 479986309
    Alvaro Uribe Velez 377786907
    Alvaro Uribe Velez 305217395
    Alvaro Uribe Velez 71147321
    Alvaro Uribe Velez 219134456
    Alvaro Uribe Velez 151312932
    Alvaro Uribe Velez 280701704
    Alvaro Uribe Velez 76167502
    Alvaro Uribe Velez 389116776
    Alvaro Uribe Velez 295381243
    Alvaro Uribe Velez 289496469
    Alvaro Uribe Velez 2411508153
    Alvaro Uribe Velez 346535681
    Alvaro Uribe Velez 310049629
    Alvaro Uribe Velez 198218181
    Alvaro Uribe Velez 2575483837
    Alvaro Uribe Velez 314037400
    Alvaro Uribe Velez 1892186648
    Alvaro Uribe Velez 35667554
    Alvaro Uribe Velez 231635758
    Alvaro Uribe Velez 548906668
    Alvaro Uribe Velez 1912178808
    Alvaro Uribe Velez 9300262
    Alvaro Uribe Velez 66740100
    Alvaro Uribe Velez 20801337
    Alvaro Uribe Velez 364231268
    Alvaro Uribe Velez 374033860
    Alvaro Uribe Velez 188569473
    Alvaro Uribe Velez 1951808478
    Alvaro Uribe Velez 1276440104
    Alvaro Uribe Velez 547900965
    Alvaro Uribe Velez 95664855
    Alvaro Uribe Velez 266887932
    Alvaro Uribe Velez 1684724779
    Alvaro Uribe Velez 1199589390
    Alvaro Uribe Velez 337783129
    Alvaro Uribe Velez 244955684
    Alvaro Uribe Velez 215609438
    Alvaro Uribe Velez 1064216442
    Alvaro Uribe Velez 143132280
    Alvaro Uribe Velez 2429619508
    Alvaro Uribe Velez 2301954715
    Alvaro Uribe Velez 223901035
    Alvaro Uribe Velez 229812269
    Alvaro Uribe Velez 19923515
    Alvaro Uribe Velez 298662302
    Alvaro Uribe Velez 320568997
    Alvaro Uribe Velez 32122600
    Alvaro Uribe Velez 202922824
    Alvaro Uribe Velez 144040303
    Alvaro Uribe Velez 286425991
    Alvaro Uribe Velez 92830907
    Alvaro Uribe Velez 141745644
    Alvaro Uribe Velez 14275291
    Alvaro Uribe Velez 2239728955
    Alvaro Uribe Velez 108108618
    Alvaro Uribe Velez 606584678
    Alvaro Uribe Velez 108508960
    Alvaro Uribe Velez 149521702
    Alvaro Uribe Velez 241638714
    Alvaro Uribe Velez 34103811
    Alvaro Uribe Velez 268525305
    Alvaro Uribe Velez 392435009
    Alvaro Uribe Velez 51973536
    Alvaro Uribe Velez 80759828
    Alvaro Uribe Velez 216849810
    Alvaro Uribe Velez 265047139
    Alvaro Uribe Velez 150839258
    Alvaro Uribe Velez 173623250
    Alvaro Uribe Velez 119588510
    Alvaro Uribe Velez 294737554
    Alvaro Uribe Velez 877278906
    Alvaro Uribe Velez 47437534
    Alvaro Uribe Velez 2265517275
    Alvaro Uribe Velez 1514435568
    Alvaro Uribe Velez 254329865
    Alvaro Uribe Velez 88981269
    Alvaro Uribe Velez 68797435
    Alvaro Uribe Velez 598008519
    Alvaro Uribe Velez 6342542
    Alvaro Uribe Velez 252673978
    Alvaro Uribe Velez 112005594
    Alvaro Uribe Velez 232683912
    Alvaro Uribe Velez 2391362917
    Alvaro Uribe Velez 253150489
    Alvaro Uribe Velez 95672089
    Alvaro Uribe Velez 365292928
    Alvaro Uribe Velez 193565440
    Alvaro Uribe Velez 49468514
    Alvaro Uribe Velez 210967209
    Alvaro Uribe Velez 364391677
    Alvaro Uribe Velez 425110119
    Alvaro Uribe Velez 205724224
    Alvaro Uribe Velez 329888286
    Alvaro Uribe Velez 64476691
    Alvaro Uribe Velez 47379940
    Alvaro Uribe Velez 47803887
    Alvaro Uribe Velez 252612434
    Alvaro Uribe Velez 121615397
    Alvaro Uribe Velez 179364507
    Alvaro Uribe Velez 61098166
    Alvaro Uribe Velez 224400256
    Alvaro Uribe Velez 43105334
    Alvaro Uribe Velez 61018481
    Alvaro Uribe Velez 53460860
    Alvaro Uribe Velez 385466566
    Alvaro Uribe Velez 50651755
    Alvaro Uribe Velez 460343519
    Alvaro Uribe Velez 180861689
    Alvaro Uribe Velez 188062049
    Alvaro Uribe Velez 212763461
    Alvaro Uribe Velez 584424537
    Alvaro Uribe Velez 547048774
    Alvaro Uribe Velez 317359519
    Alvaro Uribe Velez 111646572
    Alvaro Uribe Velez 52914117
    Alvaro Uribe Velez 381204472
    Alvaro Uribe Velez 93681558
    Alvaro Uribe Velez 59824929
    Alvaro Uribe Velez 2292841237
    Alvaro Uribe Velez 88518918
    Alvaro Uribe Velez 809242160
    Alvaro Uribe Velez 55383308
    Alvaro Uribe Velez 328522217
    Alvaro Uribe Velez 614702020
    Alvaro Uribe Velez 1971430650
    Alvaro Uribe Velez 2246979255
    Alvaro Uribe Velez 321927518
    Alvaro Uribe Velez 1436348834
    Alvaro Uribe Velez 47829293
    Alvaro Uribe Velez 1517604180
    Alvaro Uribe Velez 255602592
    Alvaro Uribe Velez 214249964
    Alvaro Uribe Velez 182246116
    Alvaro Uribe Velez 156457945
    Alvaro Uribe Velez 92204416
    Alvaro Uribe Velez 164463493
    Alvaro Uribe Velez 1468484922
    Alvaro Uribe Velez 140578789
    Alvaro Uribe Velez 547797725
    Alvaro Uribe Velez 360117685
    Alvaro Uribe Velez 187647136
    Alvaro Uribe Velez 179712722
    Alvaro Uribe Velez 309174637
    Alvaro Uribe Velez 325071911
    Alvaro Uribe Velez 389853002
    Alvaro Uribe Velez 349367980
    Alvaro Uribe Velez 157734393
    Alvaro Uribe Velez 216696569
    Alvaro Uribe Velez 2153637338
    Alvaro Uribe Velez 14681581
    Alvaro Uribe Velez 74293265
    Alvaro Uribe Velez 5402612
    Alvaro Uribe Velez 407333912
    Alvaro Uribe Velez 9624742
    Alvaro Uribe Velez 143816850
    Alvaro Uribe Velez 182225646
    Alvaro Uribe Velez 141035062
    Alvaro Uribe Velez 163671232
    Alvaro Uribe Velez 765801386
    Alvaro Uribe Velez 750382652
    Alvaro Uribe Velez 70689901
    Alvaro Uribe Velez 64294258
    Alvaro Uribe Velez 248823763
    Alvaro Uribe Velez 136773990
    Alvaro Uribe Velez 2184850352
    Alvaro Uribe Velez 1016369190
    Alvaro Uribe Velez 132645572
    Alvaro Uribe Velez 457769460
    Alvaro Uribe Velez 382372394
    Alvaro Uribe Velez 13687822
    Alvaro Uribe Velez 102531413
    Alvaro Uribe Velez 526484956
    Alvaro Uribe Velez 704307076
    Alvaro Uribe Velez 578292847
    Alvaro Uribe Velez 127897596
    Alvaro Uribe Velez 230824627
    Alvaro Uribe Velez 68999404
    Alvaro Uribe Velez 260852828
    Alvaro Uribe Velez 1972094312
    Alvaro Uribe Velez 1440132410
    Alvaro Uribe Velez 403652421
    Alvaro Uribe Velez 246990105
    Alvaro Uribe Velez 279314312
    Alvaro Uribe Velez 1701800544
    Alvaro Uribe Velez 358876617
    Alvaro Uribe Velez 72627916
    Alvaro Uribe Velez 84725346
    Alvaro Uribe Velez 260234767
    Alvaro Uribe Velez 285366215
    Alvaro Uribe Velez 165472296
    Alvaro Uribe Velez 218553284
    Alvaro Uribe Velez 318625615
    Alvaro Uribe Velez 1193216232
    Alvaro Uribe Velez 219148114
    Alvaro Uribe Velez 102601082
    Alvaro Uribe Velez 593872787
    Alvaro Uribe Velez 1480646988
    Alvaro Uribe Velez 505131607
    Alvaro Uribe Velez 157668209
    Alvaro Uribe Velez 58076336
    Alvaro Uribe Velez 1096318014
    Alvaro Uribe Velez 1046248416
    Alvaro Uribe Velez 987578959
    Alvaro Uribe Velez 325381534
    Alvaro Uribe Velez 104602841
    Alvaro Uribe Velez 88723966
    Alvaro Uribe Velez 1112893628
    Alvaro Uribe Velez 1733428952
    Alvaro Uribe Velez 200170454
    Alvaro Uribe Velez 360052201
    Alvaro Uribe Velez 615312300
    Alvaro Uribe Velez 113138316
    Alvaro Uribe Velez 47288005
    Alvaro Uribe Velez 143490635
    Alvaro Uribe Velez 192990536
    Alvaro Uribe Velez 258075414
    Alvaro Uribe Velez 241156228
    Alvaro Uribe Velez 1307736296
    Alvaro Uribe Velez 539207278
    Alvaro Uribe Velez 1571310600
    Alvaro Uribe Velez 493612802
    Alvaro Uribe Velez 191116947
    Alvaro Uribe Velez 1409137584
    Alvaro Uribe Velez 1548045696
    Alvaro Uribe Velez 361218423
    Alvaro Uribe Velez 595604505
    Alvaro Uribe Velez 355932319
    Alvaro Uribe Velez 1541967529
    Alvaro Uribe Velez 142269040
    Alvaro Uribe Velez 269918381
    Alvaro Uribe Velez 69694810
    Alvaro Uribe Velez 423096945
    Alvaro Uribe Velez 597838760
    Alvaro Uribe Velez 126792999
    Alvaro Uribe Velez 298753543
    Alvaro Uribe Velez 1589967529
    Alvaro Uribe Velez 1575604927
    Alvaro Uribe Velez 108999927
    Alvaro Uribe Velez 1092902960
    Alvaro Uribe Velez 774628742
    Alvaro Uribe Velez 289561412
    Alvaro Uribe Velez 134938656
    Alvaro Uribe Velez 326496118
    Alvaro Uribe Velez 1450133648
    Alvaro Uribe Velez 1340785496
    Alvaro Uribe Velez 33545558
    Alvaro Uribe Velez 141655177
    Alvaro Uribe Velez 14071538
    Alvaro Uribe Velez 1539878030
    Alvaro Uribe Velez 581517417
    Alvaro Uribe Velez 115944827
    Alvaro Uribe Velez 52185564
    Alvaro Uribe Velez 983120821
    Alvaro Uribe Velez 1167296532
    Alvaro Uribe Velez 473338133
    

    Rate limit reached. Sleeping for: 718
    

    Alvaro Uribe Velez 33995343
    Alvaro Uribe Velez 15248067
    Alvaro Uribe Velez 14401149
    Alvaro Uribe Velez 117109734
    Alvaro Uribe Velez 227770132
    Alvaro Uribe Velez 363994536
    Alvaro Uribe Velez 173203057
    Alvaro Uribe Velez 287857703
    Alvaro Uribe Velez 46981548
    Alvaro Uribe Velez 41280355
    Alvaro Uribe Velez 974182970
    Alvaro Uribe Velez 104881701
    Alvaro Uribe Velez 227362026
    Alvaro Uribe Velez 593765767
    Alvaro Uribe Velez 617580671
    Alvaro Uribe Velez 63296570
    Alvaro Uribe Velez 153891516
    Alvaro Uribe Velez 69206092
    Alvaro Uribe Velez 188808829
    Alvaro Uribe Velez 121169579
    Alvaro Uribe Velez 153532178
    Alvaro Uribe Velez 166549341
    Alvaro Uribe Velez 274638603
    Alvaro Uribe Velez 167496070
    Alvaro Uribe Velez 68876415
    Alvaro Uribe Velez 64604320
    Alvaro Uribe Velez 196043122
    Alvaro Uribe Velez 178697594
    Alvaro Uribe Velez 569335954
    Alvaro Uribe Velez 121144898
    Alvaro Uribe Velez 294881874
    Alvaro Uribe Velez 10228272
    Alvaro Uribe Velez 1317522541
    Alvaro Uribe Velez 1393713950
    Alvaro Uribe Velez 372862013
    Alvaro Uribe Velez 216151364
    Alvaro Uribe Velez 119860149
    Alvaro Uribe Velez 187317854
    Alvaro Uribe Velez 219416421
    Alvaro Uribe Velez 150319924
    Alvaro Uribe Velez 143835534
    Alvaro Uribe Velez 260911926
    Alvaro Uribe Velez 459686223
    Alvaro Uribe Velez 1332167533
    Alvaro Uribe Velez 146527065
    Alvaro Uribe Velez 415333454
    Alvaro Uribe Velez 860273508
    Alvaro Uribe Velez 17485551
    Alvaro Uribe Velez 1357673994
    Alvaro Uribe Velez 781349228
    Alvaro Uribe Velez 174243200
    Alvaro Uribe Velez 67653331
    Alvaro Uribe Velez 616568930
    Alvaro Uribe Velez 151921927
    Alvaro Uribe Velez 206486600
    Alvaro Uribe Velez 53778815
    Alvaro Uribe Velez 5796682
    Alvaro Uribe Velez 260290404
    Alvaro Uribe Velez 300666289
    Alvaro Uribe Velez 176561132
    Alvaro Uribe Velez 1330411524
    Alvaro Uribe Velez 552142426
    Alvaro Uribe Velez 346510738
    Alvaro Uribe Velez 78417445
    Alvaro Uribe Velez 1112915006
    Alvaro Uribe Velez 145325302
    Alvaro Uribe Velez 1323274316
    Alvaro Uribe Velez 195034077
    Alvaro Uribe Velez 132211523
    Alvaro Uribe Velez 1312136466
    Alvaro Uribe Velez 412722006
    Alvaro Uribe Velez 906610164
    Alvaro Uribe Velez 253571173
    Alvaro Uribe Velez 325325210
    Alvaro Uribe Velez 271501187
    Alvaro Uribe Velez 69416519
    Alvaro Uribe Velez 71543713
    Alvaro Uribe Velez 99411116
    Alvaro Uribe Velez 270709134
    Alvaro Uribe Velez 74327307
    Alvaro Uribe Velez 161855587
    Alvaro Uribe Velez 411205640
    Alvaro Uribe Velez 175574989
    Alvaro Uribe Velez 151193390
    Alvaro Uribe Velez 859624003
    Alvaro Uribe Velez 515029741
    Alvaro Uribe Velez 126204564
    Alvaro Uribe Velez 1090274636
    Alvaro Uribe Velez 38227815
    Alvaro Uribe Velez 45625251
    Alvaro Uribe Velez 32767938
    Alvaro Uribe Velez 538655112
    Alvaro Uribe Velez 945022842
    Alvaro Uribe Velez 1131605214
    Alvaro Uribe Velez 189280164
    Alvaro Uribe Velez 84114606
    Alvaro Uribe Velez 229184190
    Alvaro Uribe Velez 187670384
    Alvaro Uribe Velez 341645467
    Alvaro Uribe Velez 76844165
    Alvaro Uribe Velez 439448099
    Alvaro Uribe Velez 624088742
    Alvaro Uribe Velez 65681981
    Alvaro Uribe Velez 608573931
    Alvaro Uribe Velez 368551945
    Alvaro Uribe Velez 177773187
    Alvaro Uribe Velez 236018931
    Alvaro Uribe Velez 195395453
    Alvaro Uribe Velez 269788562
    Alvaro Uribe Velez 182983482
    Alvaro Uribe Velez 212942460
    Alvaro Uribe Velez 293808937
    Alvaro Uribe Velez 292712362
    Alvaro Uribe Velez 273507310
    Alvaro Uribe Velez 189200849
    Alvaro Uribe Velez 1164178921
    Alvaro Uribe Velez 203947354
    Alvaro Uribe Velez 141278382
    Alvaro Uribe Velez 124199972
    Alvaro Uribe Velez 486737346
    Alvaro Uribe Velez 152010594
    Alvaro Uribe Velez 255228815
    Alvaro Uribe Velez 175095758
    Alvaro Uribe Velez 391765969
    Alvaro Uribe Velez 607598099
    Alvaro Uribe Velez 150827347
    Alvaro Uribe Velez 176331517
    Alvaro Uribe Velez 617491645
    Alvaro Uribe Velez 778466498
    Alvaro Uribe Velez 1110254012
    Alvaro Uribe Velez 284708747
    Alvaro Uribe Velez 349780099
    Alvaro Uribe Velez 19236074
    Alvaro Uribe Velez 295934325
    Alvaro Uribe Velez 1049989213
    Alvaro Uribe Velez 226419214
    Alvaro Uribe Velez 260717324
    Alvaro Uribe Velez 44409004
    Alvaro Uribe Velez 17006157
    Alvaro Uribe Velez 525264466
    Alvaro Uribe Velez 500704345
    Alvaro Uribe Velez 218626985
    Alvaro Uribe Velez 945012782
    Alvaro Uribe Velez 17093617
    Alvaro Uribe Velez 133164590
    Alvaro Uribe Velez 58531272
    Alvaro Uribe Velez 272125861
    Alvaro Uribe Velez 293353729
    Alvaro Uribe Velez 466508803
    Alvaro Uribe Velez 403539928
    Alvaro Uribe Velez 497845987
    Alvaro Uribe Velez 150341096
    Alvaro Uribe Velez 126440093
    Alvaro Uribe Velez 222180430
    Alvaro Uribe Velez 141062052
    Alvaro Uribe Velez 138230562
    Alvaro Uribe Velez 495218221
    Alvaro Uribe Velez 481471888
    Alvaro Uribe Velez 97452391
    Alvaro Uribe Velez 537393234
    Alvaro Uribe Velez 267480434
    Alvaro Uribe Velez 258648811
    Alvaro Uribe Velez 141808819
    Alvaro Uribe Velez 59721775
    Alvaro Uribe Velez 801372464
    Alvaro Uribe Velez 401779451
    Alvaro Uribe Velez 703502070
    Alvaro Uribe Velez 135252488
    Alvaro Uribe Velez 588015764
    Alvaro Uribe Velez 255621515
    Alvaro Uribe Velez 127898886
    Alvaro Uribe Velez 921277093
    Alvaro Uribe Velez 74339331
    Alvaro Uribe Velez 41917245
    Alvaro Uribe Velez 2416531
    Alvaro Uribe Velez 26152492
    Alvaro Uribe Velez 152112161
    Alvaro Uribe Velez 137925640
    Alvaro Uribe Velez 588216760
    Alvaro Uribe Velez 152363628
    Alvaro Uribe Velez 15973392
    Alvaro Uribe Velez 878956220
    Alvaro Uribe Velez 105603840
    Alvaro Uribe Velez 9411482
    Alvaro Uribe Velez 428333
    Alvaro Uribe Velez 239946162
    Alvaro Uribe Velez 355200441
    Alvaro Uribe Velez 149962735
    Alvaro Uribe Velez 110213431
    Alvaro Uribe Velez 575765249
    Alvaro Uribe Velez 758287453
    Alvaro Uribe Velez 63847576
    Alvaro Uribe Velez 52536992
    Alvaro Uribe Velez 145903908
    Alvaro Uribe Velez 119054672
    Alvaro Uribe Velez 80139207
    Alvaro Uribe Velez 207674579
    Alvaro Uribe Velez 161397988
    Alvaro Uribe Velez 177001887
    Alvaro Uribe Velez 71407924
    Alvaro Uribe Velez 260198135
    Alvaro Uribe Velez 99845052
    Alvaro Uribe Velez 141099026
    Alvaro Uribe Velez 514583039
    Alvaro Uribe Velez 68881468
    Alvaro Uribe Velez 622082899
    Alvaro Uribe Velez 56151097
    Alvaro Uribe Velez 7827962
    Alvaro Uribe Velez 31129117
    Alvaro Uribe Velez 613751151
    Alvaro Uribe Velez 344726222
    Alvaro Uribe Velez 495996673
    Alvaro Uribe Velez 233039780
    Alvaro Uribe Velez 234979485
    Alvaro Uribe Velez 285294793
    Alvaro Uribe Velez 776384846
    Alvaro Uribe Velez 208373906
    Alvaro Uribe Velez 201398373
    Alvaro Uribe Velez 62612630
    Alvaro Uribe Velez 139511973
    Alvaro Uribe Velez 150397339
    Alvaro Uribe Velez 216915653
    Alvaro Uribe Velez 159952167
    Alvaro Uribe Velez 63770191
    Alvaro Uribe Velez 80190277
    Alvaro Uribe Velez 34037507
    Alvaro Uribe Velez 118202516
    Alvaro Uribe Velez 37813432
    Alvaro Uribe Velez 48144146
    Alvaro Uribe Velez 139602027
    Alvaro Uribe Velez 306848880
    Alvaro Uribe Velez 596539015
    Alvaro Uribe Velez 31705519
    Alvaro Uribe Velez 614607204
    Alvaro Uribe Velez 27570569
    Alvaro Uribe Velez 595653152
    Alvaro Uribe Velez 41704249
    Alvaro Uribe Velez 49320282
    Alvaro Uribe Velez 146269675
    Alvaro Uribe Velez 331078964
    Alvaro Uribe Velez 122876620
    Alvaro Uribe Velez 48132495
    Alvaro Uribe Velez 601314252
    Alvaro Uribe Velez 581327440
    Alvaro Uribe Velez 69999800
    Alvaro Uribe Velez 39621575
    Alvaro Uribe Velez 238289144
    Alvaro Uribe Velez 164515317
    Alvaro Uribe Velez 32309773
    Alvaro Uribe Velez 107882599
    Alvaro Uribe Velez 78077245
    Alvaro Uribe Velez 150079309
    Alvaro Uribe Velez 80318442
    Alvaro Uribe Velez 29308648
    Alvaro Uribe Velez 256274577
    Alvaro Uribe Velez 22685200
    Alvaro Uribe Velez 436127369
    Alvaro Uribe Velez 307902059
    Alvaro Uribe Velez 45950009
    Alvaro Uribe Velez 47491330
    Alvaro Uribe Velez 76326090
    Alvaro Uribe Velez 566864263
    Alvaro Uribe Velez 566890146
    Alvaro Uribe Velez 385090596
    Alvaro Uribe Velez 162926902
    Alvaro Uribe Velez 36278714
    Alvaro Uribe Velez 40533752
    Alvaro Uribe Velez 82697443
    Alvaro Uribe Velez 35785401
    Alvaro Uribe Velez 14333756
    Alvaro Uribe Velez 262872637
    Alvaro Uribe Velez 130249056
    Alvaro Uribe Velez 115570450
    Alvaro Uribe Velez 80403388
    Alvaro Uribe Velez 135967746
    Alvaro Uribe Velez 369282151
    Alvaro Uribe Velez 59457187
    Alvaro Uribe Velez 31459537
    Alvaro Uribe Velez 379852515
    Alvaro Uribe Velez 134628869
    Alvaro Uribe Velez 823905
    Alvaro Uribe Velez 15432218
    Alvaro Uribe Velez 387519542
    Alvaro Uribe Velez 248482004
    Alvaro Uribe Velez 17813487
    Alvaro Uribe Velez 49658852
    Alvaro Uribe Velez 350862112
    Alvaro Uribe Velez 225197388
    Alvaro Uribe Velez 403909017
    Alvaro Uribe Velez 91685464
    Alvaro Uribe Velez 91488267
    Alvaro Uribe Velez 288471451
    Alvaro Uribe Velez 112412293
    Alvaro Uribe Velez 53236186
    Alvaro Uribe Velez 247429123
    Alvaro Uribe Velez 108389784
    Alvaro Uribe Velez 142379840
    Alvaro Uribe Velez 67167025
    Alvaro Uribe Velez 363410722
    Alvaro Uribe Velez 454099919
    Alvaro Uribe Velez 32211946
    Alvaro Uribe Velez 144688278
    Alvaro Uribe Velez 147065253
    Alvaro Uribe Velez 272668932
    Alvaro Uribe Velez 218452892
    Alvaro Uribe Velez 230880706
    Alvaro Uribe Velez 42434332
    Alvaro Uribe Velez 71183932
    Alvaro Uribe Velez 124172948
    Alvaro Uribe Velez 6015212
    Alvaro Uribe Velez 123020840
    Alvaro Uribe Velez 5988062
    Alvaro Uribe Velez 130687922
    Alvaro Uribe Velez 199481710
    Alvaro Uribe Velez 368951091
    Alvaro Uribe Velez 387192348
    Alvaro Uribe Velez 258164062
    Alvaro Uribe Velez 14050583
    Alvaro Uribe Velez 7996082
    Alvaro Uribe Velez 147819325
    Alvaro Uribe Velez 268492704
    Alvaro Uribe Velez 66797683
    Alvaro Uribe Velez 140083975
    Alvaro Uribe Velez 257143407
    Alvaro Uribe Velez 281846701
    Alvaro Uribe Velez 217998640
    Alvaro Uribe Velez 388937522
    Alvaro Uribe Velez 44670915
    Alvaro Uribe Velez 297625162
    Alvaro Uribe Velez 380101019
    Alvaro Uribe Velez 68794974
    Alvaro Uribe Velez 304615687
    Alvaro Uribe Velez 257142870
    Alvaro Uribe Velez 283234293
    Alvaro Uribe Velez 9059662
    Alvaro Uribe Velez 200091982
    Alvaro Uribe Velez 45606887
    Alvaro Uribe Velez 169235632
    Alvaro Uribe Velez 187754445
    Alvaro Uribe Velez 130239696
    Alvaro Uribe Velez 172732710
    Alvaro Uribe Velez 218252776
    Alvaro Uribe Velez 73806860
    Alvaro Uribe Velez 355533614
    Alvaro Uribe Velez 252235533
    Alvaro Uribe Velez 351120934
    Alvaro Uribe Velez 18396299
    Alvaro Uribe Velez 149208619
    Alvaro Uribe Velez 21634567
    Alvaro Uribe Velez 223277224
    Alvaro Uribe Velez 58650958
    Alvaro Uribe Velez 176997632
    Alvaro Uribe Velez 58677692
    Alvaro Uribe Velez 262349588
    Alvaro Uribe Velez 223110180
    Alvaro Uribe Velez 307515713
    Alvaro Uribe Velez 124047422
    Alvaro Uribe Velez 250265046
    Alvaro Uribe Velez 283318070
    Alvaro Uribe Velez 149281495
    Alvaro Uribe Velez 117942584
    Alvaro Uribe Velez 205946231
    Alvaro Uribe Velez 317838777
    Alvaro Uribe Velez 262450005
    Alvaro Uribe Velez 319158924
    Alvaro Uribe Velez 28058878
    Alvaro Uribe Velez 49346431
    Alvaro Uribe Velez 254369839
    Alvaro Uribe Velez 70363243
    Alvaro Uribe Velez 30686300
    Alvaro Uribe Velez 50859813
    Alvaro Uribe Velez 237997611
    Alvaro Uribe Velez 214505091
    Alvaro Uribe Velez 124355265
    Alvaro Uribe Velez 183308316
    Alvaro Uribe Velez 186227903
    Alvaro Uribe Velez 185763733
    Alvaro Uribe Velez 174693068
    Alvaro Uribe Velez 102482331
    Alvaro Uribe Velez 86331057
    Alvaro Uribe Velez 228498336
    Alvaro Uribe Velez 213162575
    Alvaro Uribe Velez 15907720
    Alvaro Uribe Velez 33039483
    Alvaro Uribe Velez 150544186
    Alvaro Uribe Velez 53778621
    Alvaro Uribe Velez 283624167
    Alvaro Uribe Velez 14114420
    Alvaro Uribe Velez 75883996
    Alvaro Uribe Velez 92399925
    Alvaro Uribe Velez 185892161
    Alvaro Uribe Velez 59191760
    Alvaro Uribe Velez 143166984
    Alvaro Uribe Velez 127059349
    Alvaro Uribe Velez 52695076
    Alvaro Uribe Velez 127073570
    Alvaro Uribe Velez 35612204
    Alvaro Uribe Velez 36186928
    Alvaro Uribe Velez 27927871
    Alvaro Uribe Velez 232868113
    Alvaro Uribe Velez 249450698
    Alvaro Uribe Velez 229880392
    Alvaro Uribe Velez 274179881
    Alvaro Uribe Velez 262814659
    Alvaro Uribe Velez 133945128
    Alvaro Uribe Velez 269319630
    Alvaro Uribe Velez 71294756
    Alvaro Uribe Velez 142849205
    Alvaro Uribe Velez 248918439
    Alvaro Uribe Velez 52968700
    Alvaro Uribe Velez 268307042
    Alvaro Uribe Velez 192941442
    Alvaro Uribe Velez 18559380
    Alvaro Uribe Velez 144376833
    Alvaro Uribe Velez 180113520
    Alvaro Uribe Velez 48462806
    Alvaro Uribe Velez 56754332
    Alvaro Uribe Velez 125733854
    Alvaro Uribe Velez 116827501
    Alvaro Uribe Velez 36589869
    Alvaro Uribe Velez 226794223
    Alvaro Uribe Velez 183764941
    Alvaro Uribe Velez 67812003
    Alvaro Uribe Velez 50182971
    Alvaro Uribe Velez 141038736
    Alvaro Uribe Velez 253226629
    Alvaro Uribe Velez 13058232
    Alvaro Uribe Velez 12925072
    Alvaro Uribe Velez 34535086
    Alvaro Uribe Velez 166967644
    Alvaro Uribe Velez 109163316
    Alvaro Uribe Velez 128023818
    Alvaro Uribe Velez 250147996
    Alvaro Uribe Velez 175806207
    Alvaro Uribe Velez 219337269
    Alvaro Uribe Velez 190412668
    Alvaro Uribe Velez 75733989
    Alvaro Uribe Velez 29202899
    Alvaro Uribe Velez 196391831
    Alvaro Uribe Velez 35013719
    Alvaro Uribe Velez 20655505
    Alvaro Uribe Velez 33884545
    Alvaro Uribe Velez 20560294
    Alvaro Uribe Velez 69181624
    Alvaro Uribe Velez 24376343
    Alvaro Uribe Velez 126560662
    Alvaro Uribe Velez 742143
    Alvaro Uribe Velez 106179024
    Alvaro Uribe Velez 63773715
    Alvaro Uribe Velez 30250196
    Alvaro Uribe Velez 144256050
    Alvaro Uribe Velez 813286
    Alvaro Uribe Velez 85867670
    Alvaro Uribe Velez 220055314
    Alvaro Uribe Velez 116488477
    Alvaro Uribe Velez 41837261
    Alvaro Uribe Velez 109646676
    Alvaro Uribe Velez 44815900
    Alvaro Uribe Velez 113047940
    Alvaro Uribe Velez 2467791
    Alvaro Uribe Velez 179722950
    Alvaro Uribe Velez 38866099
    Alvaro Uribe Velez 108717093
    Alvaro Uribe Velez 52819651
    Alvaro Uribe Velez 118215857
    Alvaro Uribe Velez 99075548
    Alvaro Uribe Velez 170714191
    Alvaro Uribe Velez 75887671
    Alvaro Uribe Velez 225422644
    Alvaro Uribe Velez 185859540
    Alvaro Uribe Velez 9633802
    Alvaro Uribe Velez 137758797
    Alvaro Uribe Velez 31349492
    Alvaro Uribe Velez 43395943
    Alvaro Uribe Velez 46575633
    Alvaro Uribe Velez 82740524
    Alvaro Uribe Velez 147734376
    Alvaro Uribe Velez 229519099
    Alvaro Uribe Velez 29335914
    Alvaro Uribe Velez 118202267
    Alvaro Uribe Velez 149113224
    Alvaro Uribe Velez 65789341
    Alvaro Uribe Velez 111943334
    Alvaro Uribe Velez 64049591
    Alvaro Uribe Velez 139121148
    Alvaro Uribe Velez 64419705
    Alvaro Uribe Velez 63796077
    Alvaro Uribe Velez 202644027
    Alvaro Uribe Velez 21860431
    Alvaro Uribe Velez 208241578
    Alvaro Uribe Velez 118117109
    Alvaro Uribe Velez 157740420
    Alvaro Uribe Velez 191955247
    Alvaro Uribe Velez 83466973
    Alvaro Uribe Velez 103455059
    Alvaro Uribe Velez 220742710
    Alvaro Uribe Velez 197836097
    Alvaro Uribe Velez 138922361
    Alvaro Uribe Velez 178878001
    Alvaro Uribe Velez 145774770
    Alvaro Uribe Velez 200993009
    Alvaro Uribe Velez 44197786
    Alvaro Uribe Velez 74298835
    Alvaro Uribe Velez 46733926
    Alvaro Uribe Velez 95906416
    Alvaro Uribe Velez 136092143
    Alvaro Uribe Velez 114983334
    Alvaro Uribe Velez 64196402
    Alvaro Uribe Velez 132254028
    Alvaro Uribe Velez 12590532
    Alvaro Uribe Velez 138422750
    Alvaro Uribe Velez 44171543
    Alvaro Uribe Velez 184124485
    Alvaro Uribe Velez 190434625
    Alvaro Uribe Velez 118741740
    Alvaro Uribe Velez 131071185
    Alvaro Uribe Velez 141681382
    Alvaro Uribe Velez 141662229
    Alvaro Uribe Velez 165324471
    Alvaro Uribe Velez 143278545
    Alvaro Uribe Velez 50107849
    Alvaro Uribe Velez 198984928
    Alvaro Uribe Velez 35565617
    Alvaro Uribe Velez 175813609
    Alvaro Uribe Velez 95300066
    Alvaro Uribe Velez 142027267
    Alvaro Uribe Velez 91916987
    Alvaro Uribe Velez 116600073
    Alvaro Uribe Velez 131378594
    Alvaro Uribe Velez 74804967
    Alvaro Uribe Velez 203530112
    Alvaro Uribe Velez 169213928
    Alvaro Uribe Velez 59459771
    Alvaro Uribe Velez 184590625
    Alvaro Uribe Velez 176441586
    Alvaro Uribe Velez 56739173
    Alvaro Uribe Velez 77694285
    Alvaro Uribe Velez 136243285
    Alvaro Uribe Velez 23004614
    Alvaro Uribe Velez 18401107
    Alvaro Uribe Velez 77653794
    Alvaro Uribe Velez 22488241
    Alvaro Uribe Velez 21891923
    Alvaro Uribe Velez 149367625
    Alvaro Uribe Velez 91383477
    Alvaro Uribe Velez 56724999
    Alvaro Uribe Velez 91181758
    Alvaro Uribe Velez 63478213
    Alvaro Uribe Velez 126672796
    Alvaro Uribe Velez 146877835
    Alvaro Uribe Velez 69432342
    Alvaro Uribe Velez 131273553
    Alvaro Uribe Velez 89036572
    Alvaro Uribe Velez 15404821
    Alvaro Uribe Velez 44946232
    Alvaro Uribe Velez 23547038
    Sergio Fajardo 984087413864783872
    Sergio Fajardo 1180020318
    Sergio Fajardo 2830440814
    Sergio Fajardo 48087492
    Sergio Fajardo 161280980
    Sergio Fajardo 3173171871
    Sergio Fajardo 974070525252243456
    Sergio Fajardo 37341338
    Sergio Fajardo 38161550
    Sergio Fajardo 330378253
    Sergio Fajardo 42507268
    Sergio Fajardo 33148967
    Sergio Fajardo 53071966
    Sergio Fajardo 111689516
    Sergio Fajardo 474196408
    Sergio Fajardo 60247069
    Sergio Fajardo 17572957
    Sergio Fajardo 49638313
    Sergio Fajardo 123573420
    Sergio Fajardo 107279177
    Sergio Fajardo 48047186
    Sergio Fajardo 823518894182846464
    Sergio Fajardo 38508530
    Sergio Fajardo 392394776
    Sergio Fajardo 919992880500035584
    Sergio Fajardo 297714003
    Sergio Fajardo 170714191
    Sergio Fajardo 909983578808864768
    Sergio Fajardo 78188601
    Sergio Fajardo 15160529
    Sergio Fajardo 354510518
    Sergio Fajardo 2203846819
    Sergio Fajardo 26885338
    Sergio Fajardo 823348278830002177
    Sergio Fajardo 42434332
    Sergio Fajardo 186227903
    Sergio Fajardo 43105334
    Sergio Fajardo 40988451
    Sergio Fajardo 480974066
    Sergio Fajardo 32211946
    Sergio Fajardo 2196268872
    Sergio Fajardo 37813432
    Sergio Fajardo 197962366
    Sergio Fajardo 2802131639
    Sergio Fajardo 553075553
    Sergio Fajardo 60158253
    Sergio Fajardo 920198755
    Sergio Fajardo 241155971
    Sergio Fajardo 215375158
    Sergio Fajardo 268322810
    Sergio Fajardo 3300493816
    Sergio Fajardo 2657014352
    Sergio Fajardo 379855529
    Sergio Fajardo 77694285
    Sergio Fajardo 22029874
    Sergio Fajardo 327553766
    Sergio Fajardo 49681553
    Sergio Fajardo 56599191
    Sergio Fajardo 863598180
    Sergio Fajardo 631580827
    Sergio Fajardo 206309260
    Sergio Fajardo 294591289
    Sergio Fajardo 40918718
    Sergio Fajardo 115237579
    Sergio Fajardo 633912413
    Sergio Fajardo 72936748
    Sergio Fajardo 217451555
    Sergio Fajardo 234140838
    Sergio Fajardo 214076026
    Sergio Fajardo 93924256
    Sergio Fajardo 289172414
    Sergio Fajardo 43325454
    Sergio Fajardo 337783129
    Sergio Fajardo 139121148
    Sergio Fajardo 59459771
    Sergio Fajardo 39313353
    Sergio Fajardo 25493114
    Sergio Fajardo 2713176725
    Sergio Fajardo 445078300
    Sergio Fajardo 326920504
    Sergio Fajardo 2211274982
    Sergio Fajardo 731897822103126016
    Sergio Fajardo 559207602
    Sergio Fajardo 518996754
    Sergio Fajardo 64925578
    Sergio Fajardo 47288005
    Sergio Fajardo 704657030762663936
    Sergio Fajardo 152010594
    Sergio Fajardo 595653152
    Sergio Fajardo 303482958
    Sergio Fajardo 705484506
    Sergio Fajardo 177213595
    Sergio Fajardo 178618014
    Sergio Fajardo 67145782
    Sergio Fajardo 1425639174
    Sergio Fajardo 73954053
    Sergio Fajardo 189192159
    Sergio Fajardo 62945553
    Sergio Fajardo 3171885767
    Sergio Fajardo 54788305
    Sergio Fajardo 66740100
    Sergio Fajardo 56739173
    Sergio Fajardo 85959510
    Sergio Fajardo 3044752787
    Sergio Fajardo 327114221
    Sergio Fajardo 20560294
    Sergio Fajardo 175806207
    Sergio Fajardo 2531142691
    Sergio Fajardo 56385497
    Sergio Fajardo 2296148125
    Sergio Fajardo 2615599655
    Sergio Fajardo 1445367414
    Sergio Fajardo 1592102694
    Sergio Fajardo 745314768
    Sergio Fajardo 468621289
    Sergio Fajardo 173894987
    Sergio Fajardo 67654599
    Sergio Fajardo 82531058
    Sergio Fajardo 297658709
    Sergio Fajardo 40031040
    Sergio Fajardo 141245467
    Sergio Fajardo 69731506
    Sergio Fajardo 231824059
    Sergio Fajardo 306231892
    Sergio Fajardo 169988213
    Sergio Fajardo 165230785
    Sergio Fajardo 94097582
    Sergio Fajardo 15114233
    Sergio Fajardo 12693832
    Sergio Fajardo 104975464
    Sergio Fajardo 174286073
    Sergio Fajardo 50914819
    Sergio Fajardo 17633059
    Sergio Fajardo 74064833
    Sergio Fajardo 153514175
    Sergio Fajardo 444872186
    Sergio Fajardo 67755133
    Sergio Fajardo 17108678
    Sergio Fajardo 62305063
    Sergio Fajardo 68707712
    Sergio Fajardo 44645460
    Sergio Fajardo 21381934
    Sergio Fajardo 16059026
    Sergio Fajardo 57123884
    Sergio Fajardo 192990536
    Sergio Fajardo 174443391
    Sergio Fajardo 201398373
    Sergio Fajardo 976984256
    Sergio Fajardo 1280370877
    Sergio Fajardo 190876404
    Sergio Fajardo 305620049
    Sergio Fajardo 185771984
    Sergio Fajardo 847584114
    Sergio Fajardo 951970255
    Sergio Fajardo 41199590
    Sergio Fajardo 563264497
    Sergio Fajardo 570125457
    Sergio Fajardo 62625917
    Sergio Fajardo 54697124
    Sergio Fajardo 605718541
    Sergio Fajardo 82942396
    Sergio Fajardo 331008858
    Sergio Fajardo 97452391
    Sergio Fajardo 290541347
    Sergio Fajardo 147993143
    Sergio Fajardo 149912984
    Sergio Fajardo 151624064
    Sergio Fajardo 243680902
    Sergio Fajardo 165748292
    Sergio Fajardo 188808829
    Sergio Fajardo 64791701
    Sergio Fajardo 179987439
    Sergio Fajardo 461567449
    Sergio Fajardo 142473363
    Sergio Fajardo 69396376
    Sergio Fajardo 458755731
    Sergio Fajardo 10941072
    Sergio Fajardo 18786579
    Sergio Fajardo 221903977
    Sergio Fajardo 266637591
    Sergio Fajardo 297178430
    Sergio Fajardo 366108142
    Sergio Fajardo 60161414
    Sergio Fajardo 813286
    Sergio Fajardo 64839766
    Sergio Fajardo 176931171
    Sergio Fajardo 142306651
    Sergio Fajardo 248760009
    Sergio Fajardo 202644027
    Sergio Fajardo 142849205
    Sergio Fajardo 104861330
    Sergio Fajardo 154294030
    Sergio Fajardo 57174405
    Sergio Fajardo 142250577
    Sergio Fajardo 21938850
    Sergio Fajardo 20456814
    Sergio Fajardo 34798360
    Sergio Fajardo 50442705
    Sergio Fajardo 137908875
    Sergio Fajardo 174492304
    Sergio Fajardo 87266285
    Sergio Fajardo 18396299
    Sergio Fajardo 168285907
    Sergio Fajardo 41147203
    Sergio Fajardo 108717093
    Sergio Fajardo 198984928
    Sergio Fajardo 153148677
    Sergio Fajardo 253315622
    Sergio Fajardo 69516296
    Sergio Fajardo 242730842
    Sergio Fajardo 96779730
    Sergio Fajardo 334921284
    Sergio Fajardo 290672220
    Sergio Fajardo 186602339
    Sergio Fajardo 180933199
    Sergio Fajardo 98781946
    Sergio Fajardo 143850036
    Sergio Fajardo 61097151
    Sergio Fajardo 178718239
    Sergio Fajardo 219508242
    Sergio Fajardo 6003222
    Sergio Fajardo 60728305
    Sergio Fajardo 41628136
    Sergio Fajardo 49849732
    Sergio Fajardo 126832572
    Sergio Fajardo 120132111
    Sergio Fajardo 273647423
    Sergio Fajardo 223691577
    Sergio Fajardo 36016147
    Sergio Fajardo 22488241
    Sergio Fajardo 134855279
    Sergio Fajardo 15930883
    Sergio Fajardo 79819824
    Sergio Fajardo 36675552
    Sergio Fajardo 37758638
    Sergio Fajardo 35535847
    Sergio Fajardo 40003467
    Sergio Fajardo 21694210
    Sergio Fajardo 39683468
    Sergio Fajardo 21032262
    Sergio Fajardo 6342542
    Sergio Fajardo 43395943
    Sergio Fajardo 52536992
    Gustavo Petro 779073015543914496
    Gustavo Petro 990009265
    Gustavo Petro 124262339
    Gustavo Petro 3364598231
    Gustavo Petro 560549414
    Gustavo Petro 324448788
    Gustavo Petro 351726568
    Gustavo Petro 783348230654402560
    Gustavo Petro 65185268
    Gustavo Petro 60619634
    Gustavo Petro 3080637873
    Gustavo Petro 78706973
    Gustavo Petro 632923322
    Gustavo Petro 848923514119884800
    Gustavo Petro 284684587
    Gustavo Petro 938783900209504256
    Gustavo Petro 142820755
    Gustavo Petro 3199134149
    Gustavo Petro 206802896
    Gustavo Petro 93122443
    Gustavo Petro 242448965
    Gustavo Petro 91233011
    Gustavo Petro 949747223520272385
    Gustavo Petro 12542002
    Gustavo Petro 352050284
    Gustavo Petro 961458944882499585
    Gustavo Petro 742717325577748480
    Gustavo Petro 153185304
    Gustavo Petro 98742227
    Gustavo Petro 951974612694437889
    Gustavo Petro 407330168
    Gustavo Petro 877236050397147136
    Gustavo Petro 1552186375
    Gustavo Petro 519926293
    Gustavo Petro 1620557732
    Gustavo Petro 49946953
    Gustavo Petro 952940014131990528
    Gustavo Petro 3089466687
    Gustavo Petro 945996964608593920
    Gustavo Petro 308245641
    Gustavo Petro 38732964
    Gustavo Petro 37231268
    Gustavo Petro 1697160798
    Gustavo Petro 756992567095463937
    Gustavo Petro 3130011701
    Gustavo Petro 352651860
    Gustavo Petro 57664761
    Gustavo Petro 20374262
    Gustavo Petro 839164116921106432
    Gustavo Petro 774643608079241216
    Gustavo Petro 2726937249
    Gustavo Petro 840221879193468928
    Gustavo Petro 374339183
    Gustavo Petro 1338952788
    Gustavo Petro 83002758
    Gustavo Petro 2212875043
    Gustavo Petro 928354438292664320
    Gustavo Petro 1466003185
    Gustavo Petro 938019685924331521
    Gustavo Petro 41048726
    Gustavo Petro 4828309093
    Gustavo Petro 3621289273
    Gustavo Petro 910921907062657025
    Gustavo Petro 925183980160339968
    Gustavo Petro 3252822237
    Gustavo Petro 2179994252
    Gustavo Petro 162278521
    Gustavo Petro 635048260
    Gustavo Petro 17028666
    Gustavo Petro 38533136
    Gustavo Petro 481397009
    Gustavo Petro 875222185
    Gustavo Petro 11611502
    Gustavo Petro 1644228493
    Gustavo Petro 928851506
    Gustavo Petro 801218386684477441
    Gustavo Petro 323790260
    Gustavo Petro 19003727
    Gustavo Petro 2790057867
    Gustavo Petro 77875062
    Gustavo Petro 1164609008
    Gustavo Petro 738831888081661952
    Gustavo Petro 870047110015668224
    Gustavo Petro 1020728958
    Gustavo Petro 84838078
    Gustavo Petro 302103306
    Gustavo Petro 732049512819249153
    Gustavo Petro 297515020
    Gustavo Petro 63005608
    Gustavo Petro 604840570
    Gustavo Petro 45954308
    Gustavo Petro 2303159468
    Gustavo Petro 740213526673915904
    Gustavo Petro 2453537065
    Gustavo Petro 346047922
    Gustavo Petro 123463473
    Gustavo Petro 581210185
    Gustavo Petro 142092456
    Gustavo Petro 882667874241871874
    Gustavo Petro 173323500
    Gustavo Petro 483081870
    Gustavo Petro 415588233
    

    Rate limit reached. Sleeping for: 696
    

    Gustavo Petro 2688286646
    Gustavo Petro 3368201829
    Gustavo Petro 150460030
    Gustavo Petro 2935805182
    Gustavo Petro 1663849950
    Gustavo Petro 258969070
    Gustavo Petro 578052338
    Gustavo Petro 140535932
    Gustavo Petro 55273142
    Gustavo Petro 4362242296
    Gustavo Petro 703394216
    Gustavo Petro 1216071709
    Gustavo Petro 2825483244
    Gustavo Petro 3753565222
    Gustavo Petro 2582629795
    Gustavo Petro 1959362209
    Gustavo Petro 4898884923
    Gustavo Petro 2775673675
    Gustavo Petro 162487041
    Gustavo Petro 1637405582
    Gustavo Petro 211352920
    Gustavo Petro 197266208
    Gustavo Petro 273097602
    Gustavo Petro 1332568796
    Gustavo Petro 748022384561688576
    Gustavo Petro 70480069
    Gustavo Petro 152020269
    Gustavo Petro 867726186843168768
    Gustavo Petro 964992871
    Gustavo Petro 133584473
    Gustavo Petro 2948653018
    Gustavo Petro 444056712
    Gustavo Petro 759612380
    Gustavo Petro 813286
    Gustavo Petro 208308070
    Gustavo Petro 1409084288
    Gustavo Petro 64419705
    Gustavo Petro 2474471474
    Gustavo Petro 859739074466369541
    Gustavo Petro 19811190
    Gustavo Petro 14917589
    Gustavo Petro 2844984405
    Gustavo Petro 101848693
    Gustavo Petro 1412275207
    Gustavo Petro 319268829
    Gustavo Petro 2419819328
    Gustavo Petro 597499972
    Gustavo Petro 322623953
    Gustavo Petro 1477372160
    Gustavo Petro 69659744
    Gustavo Petro 2933084458
    Gustavo Petro 71559454
    Gustavo Petro 2289902753
    Gustavo Petro 205934870
    Gustavo Petro 113660988
    Gustavo Petro 852525626611388420
    Gustavo Petro 832289418232856576
    Gustavo Petro 1269505394
    Gustavo Petro 3148728906
    Gustavo Petro 39483072
    Gustavo Petro 3096601247
    Gustavo Petro 210102008
    Gustavo Petro 913131817
    Gustavo Petro 3116308811
    Gustavo Petro 267939039
    Gustavo Petro 76702792
    Gustavo Petro 30054530
    Gustavo Petro 175532137
    Gustavo Petro 80391585
    Gustavo Petro 303999006
    Gustavo Petro 47855400
    Gustavo Petro 18441350
    Gustavo Petro 2549995414
    Gustavo Petro 264950596
    Gustavo Petro 4119914644
    Gustavo Petro 88518918
    Gustavo Petro 3017705518
    Gustavo Petro 76464727
    Gustavo Petro 79585327
    Gustavo Petro 1612788259
    Gustavo Petro 155710336
    Gustavo Petro 359087483
    Gustavo Petro 923693461
    Gustavo Petro 87285453
    Gustavo Petro 319284821
    Gustavo Petro 2252550380
    Gustavo Petro 888007964
    Gustavo Petro 1390094958
    Gustavo Petro 178463022
    Gustavo Petro 1270068241
    Gustavo Petro 58650958
    Gustavo Petro 832247006286450690
    Gustavo Petro 107552305
    Gustavo Petro 1436400703
    Gustavo Petro 132570884
    Gustavo Petro 211875081
    Gustavo Petro 1592501881
    Gustavo Petro 263766735
    Gustavo Petro 71629877
    Gustavo Petro 143177134
    Gustavo Petro 14050583
    Gustavo Petro 2564173448
    Gustavo Petro 3242884521
    Gustavo Petro 1498475484
    Gustavo Petro 2977101455
    Gustavo Petro 803495444529692672
    Gustavo Petro 701901139982295040
    Gustavo Petro 773284742926073856
    Gustavo Petro 277598238
    Gustavo Petro 166593565
    Gustavo Petro 308227973
    Gustavo Petro 2366596837
    Gustavo Petro 425179255
    Gustavo Petro 436867666
    Gustavo Petro 1539520063
    Gustavo Petro 781109556667682818
    Gustavo Petro 601163523
    Gustavo Petro 965069750
    Gustavo Petro 410762826
    Gustavo Petro 2816433530
    Gustavo Petro 2853492725
    Gustavo Petro 783233060
    Gustavo Petro 403076756
    Gustavo Petro 780895473494290432
    Gustavo Petro 1471893511
    Gustavo Petro 17839907
    Gustavo Petro 363111053
    Gustavo Petro 779416353019203584
    Gustavo Petro 574069380
    Gustavo Petro 3376511
    Gustavo Petro 403889905
    Gustavo Petro 809049564128935936
    Gustavo Petro 2802545808
    Gustavo Petro 765926406622699520
    Gustavo Petro 287302346
    Gustavo Petro 325942330
    Gustavo Petro 3091019856
    Gustavo Petro 301698721
    Gustavo Petro 772991487311245312
    Gustavo Petro 293295551
    Gustavo Petro 2440326373
    Gustavo Petro 229532257
    Gustavo Petro 24184892
    Gustavo Petro 14957147
    Gustavo Petro 618300542
    Gustavo Petro 2830440814
    Gustavo Petro 2177593573
    Gustavo Petro 707633643150135296
    Gustavo Petro 2958686675
    Gustavo Petro 771800846724104192
    Gustavo Petro 781223102726410241
    Gustavo Petro 128564410
    Gustavo Petro 52419142
    Gustavo Petro 1077391080
    Gustavo Petro 2480387448
    Gustavo Petro 2684210810
    Gustavo Petro 1695346099
    Gustavo Petro 3041729411
    Gustavo Petro 291401714
    Gustavo Petro 137567961
    Gustavo Petro 794190959126937605
    Gustavo Petro 3313777485
    Gustavo Petro 568298828
    Gustavo Petro 133880286
    Gustavo Petro 506106288
    Gustavo Petro 1729561250
    Gustavo Petro 775798423924666369
    Gustavo Petro 310385214
    Gustavo Petro 4495233135
    Gustavo Petro 368711188
    Gustavo Petro 3087424378
    Gustavo Petro 3039539267
    Gustavo Petro 113062227
    Gustavo Petro 270472877
    Gustavo Petro 790637861871771648
    Gustavo Petro 167156413
    Gustavo Petro 77653794
    Gustavo Petro 260406854
    Gustavo Petro 193095342
    Gustavo Petro 81636991
    Gustavo Petro 1020173659
    Gustavo Petro 93048372
    Gustavo Petro 3666317307
    Gustavo Petro 1093667972
    Gustavo Petro 783333972885573632
    Gustavo Petro 354095556
    Gustavo Petro 4363420577
    Gustavo Petro 771645044
    Gustavo Petro 548515036
    Gustavo Petro 14525982
    Gustavo Petro 2250278832
    Gustavo Petro 251804080
    Gustavo Petro 702258800187801600
    Gustavo Petro 1319390838
    Gustavo Petro 142802581
    Gustavo Petro 770378969153671169
    Gustavo Petro 720786569792253952
    Gustavo Petro 53071966
    Gustavo Petro 10228272
    Gustavo Petro 4838567890
    Gustavo Petro 735199719891177472
    Gustavo Petro 745485072724168704
    Gustavo Petro 134629415
    Gustavo Petro 146549091
    Gustavo Petro 18757892
    Gustavo Petro 19725644
    Gustavo Petro 732660074947223556
    Gustavo Petro 712414857832894465
    Gustavo Petro 343637138
    Gustavo Petro 3320971030
    Gustavo Petro 722950850
    Gustavo Petro 554589474
    Gustavo Petro 2211274982
    Gustavo Petro 2891161305
    Gustavo Petro 111691454
    Gustavo Petro 3094977521
    Gustavo Petro 106946247
    Gustavo Petro 4719187769
    Gustavo Petro 3374091909
    Gustavo Petro 889157791
    Gustavo Petro 42932403
    Gustavo Petro 974748966
    Gustavo Petro 325221598
    Gustavo Petro 118864905
    Gustavo Petro 1286050129
    Gustavo Petro 278254768
    Gustavo Petro 2395269181
    Gustavo Petro 186602988
    Gustavo Petro 1540034828
    Gustavo Petro 576545125
    Gustavo Petro 81629449
    Gustavo Petro 111216716
    Gustavo Petro 709863764594696196
    Gustavo Petro 1650330319
    Gustavo Petro 2830613548
    Gustavo Petro 214127707
    Gustavo Petro 2815477076
    Gustavo Petro 2337473174
    Gustavo Petro 349729773
    Gustavo Petro 111123176
    Gustavo Petro 4525377257
    Gustavo Petro 64839766
    Gustavo Petro 465628233
    Gustavo Petro 54312869
    Gustavo Petro 475731129
    Gustavo Petro 705176725689389057
    Gustavo Petro 70861945
    Gustavo Petro 501902406
    Gustavo Petro 80820758
    Gustavo Petro 50020558
    Gustavo Petro 2645028393
    Gustavo Petro 288381237
    Gustavo Petro 25108596
    Gustavo Petro 4916646500
    Gustavo Petro 384419751
    Gustavo Petro 838098877
    Gustavo Petro 17149381
    Gustavo Petro 2388276732
    Gustavo Petro 358445205
    Gustavo Petro 2916305152
    Gustavo Petro 85959946
    Gustavo Petro 342994346
    Gustavo Petro 14594813
    Gustavo Petro 3988096450
    Gustavo Petro 3187898110
    Gustavo Petro 33372315
    Gustavo Petro 4725805822
    Gustavo Petro 1920228356
    Gustavo Petro 148776931
    Gustavo Petro 2874285407
    Gustavo Petro 281707046
    Gustavo Petro 47837805
    Gustavo Petro 369120654
    Gustavo Petro 519964119
    Gustavo Petro 525416576
    Gustavo Petro 269058934
    Gustavo Petro 83701293
    Gustavo Petro 185344640
    Gustavo Petro 64017522
    Gustavo Petro 2572328339
    Gustavo Petro 151883398
    Gustavo Petro 543105725
    Gustavo Petro 142240353
    Gustavo Petro 606357133
    Gustavo Petro 235229278
    Gustavo Petro 126172331
    Gustavo Petro 79739010
    Gustavo Petro 4850073470
    Gustavo Petro 22014225
    Gustavo Petro 181191692
    Gustavo Petro 207247964
    Gustavo Petro 2233653906
    Gustavo Petro 331382019
    Gustavo Petro 4068347835
    Gustavo Petro 252418082
    Gustavo Petro 1089565454
    Gustavo Petro 234130696
    Gustavo Petro 2992910422
    Gustavo Petro 513919277
    Gustavo Petro 82993613
    Gustavo Petro 522627214
    Gustavo Petro 1230868171
    Gustavo Petro 3108269314
    Gustavo Petro 4354586296
    Gustavo Petro 857044176
    Gustavo Petro 323765670
    Gustavo Petro 495046768
    Gustavo Petro 2425849958
    Gustavo Petro 785282130
    Gustavo Petro 3037459757
    Gustavo Petro 850339922
    Gustavo Petro 1244925674
    Gustavo Petro 248482004
    Gustavo Petro 3222044339
    Gustavo Petro 69032746
    Gustavo Petro 304033589
    Gustavo Petro 261930277
    Gustavo Petro 1571718086
    Gustavo Petro 53683373
    Gustavo Petro 30382919
    Gustavo Petro 2255584429
    Gustavo Petro 143691543
    Gustavo Petro 273650448
    Gustavo Petro 56839855
    Gustavo Petro 10361342
    Gustavo Petro 745646359
    Gustavo Petro 372019577
    Gustavo Petro 2179361946
    Gustavo Petro 510366393
    Gustavo Petro 316926375
    Gustavo Petro 1548598573
    Gustavo Petro 110512056
    Gustavo Petro 2363288942
    Gustavo Petro 41884138
    Gustavo Petro 90750092
    Gustavo Petro 3910722082
    Gustavo Petro 2916085306
    Gustavo Petro 79848784
    Gustavo Petro 4117404074
    Gustavo Petro 3269015582
    Gustavo Petro 1564340928
    Gustavo Petro 101479103
    Gustavo Petro 214731619
    Gustavo Petro 3058981246
    Gustavo Petro 212297066
    Gustavo Petro 2548274954
    Gustavo Petro 136694594
    Gustavo Petro 2202387091
    Gustavo Petro 3974969283
    Gustavo Petro 329415263
    Gustavo Petro 155319478
    Gustavo Petro 98907038
    Gustavo Petro 57046171
    Gustavo Petro 167175311
    Gustavo Petro 73480200
    Gustavo Petro 388571387
    Gustavo Petro 577277675
    Gustavo Petro 286347628
    Gustavo Petro 366863783
    Gustavo Petro 3613535776
    Gustavo Petro 1630482632
    Gustavo Petro 805752104
    Gustavo Petro 619537827
    Gustavo Petro 782076
    Gustavo Petro 2865328068
    Gustavo Petro 4090034385
    Gustavo Petro 2198133708
    Gustavo Petro 1113127507
    Gustavo Petro 129698891
    Gustavo Petro 315214422
    Gustavo Petro 15240265
    Gustavo Petro 142755488
    Gustavo Petro 1544472212
    Gustavo Petro 31133330
    Gustavo Petro 114075048
    Gustavo Petro 1362851972
    Gustavo Petro 120626653
    Gustavo Petro 40522413
    Gustavo Petro 287915407
    Gustavo Petro 101736223
    Gustavo Petro 2999190244
    Gustavo Petro 277725370
    Gustavo Petro 1426107079
    Gustavo Petro 105082141
    Gustavo Petro 85976339
    Gustavo Petro 217085094
    Gustavo Petro 789503900
    Gustavo Petro 2939615002
    Gustavo Petro 2381350033
    Gustavo Petro 759941605
    Gustavo Petro 2151066475
    Gustavo Petro 112974466
    Gustavo Petro 203591104
    Gustavo Petro 43105334
    Gustavo Petro 2992139217
    Gustavo Petro 2466649381
    Gustavo Petro 2322374534
    Gustavo Petro 2992138403
    Gustavo Petro 2757888010
    Gustavo Petro 382402806
    Gustavo Petro 84880944
    Gustavo Petro 66177378
    Gustavo Petro 109387470
    Gustavo Petro 85426644
    Gustavo Petro 117777690
    Gustavo Petro 3071143787
    Gustavo Petro 29442313
    Gustavo Petro 983422531
    Gustavo Petro 90725961
    Gustavo Petro 48315317
    Gustavo Petro 2221123976
    Gustavo Petro 19491190
    Gustavo Petro 1543219940
    Gustavo Petro 2816924993
    Gustavo Petro 156456941
    Gustavo Petro 66219622
    Gustavo Petro 370808273
    Gustavo Petro 3366337367
    Gustavo Petro 3081857998
    Gustavo Petro 202533287
    Gustavo Petro 197896274
    Gustavo Petro 2920529865
    Gustavo Petro 37083941
    Gustavo Petro 220695429
    Gustavo Petro 817264423
    Gustavo Petro 203555695
    Gustavo Petro 3410425486
    Gustavo Petro 1179751206
    Gustavo Petro 284120734
    Gustavo Petro 34345168
    Gustavo Petro 53243862
    Gustavo Petro 124809915
    Gustavo Petro 503581789
    Gustavo Petro 184825174
    Gustavo Petro 449125915
    Gustavo Petro 14071068
    Gustavo Petro 2225215635
    Gustavo Petro 3363219466
    Gustavo Petro 1259665873
    Gustavo Petro 370115289
    Gustavo Petro 124690469
    Gustavo Petro 132392220
    Gustavo Petro 366840266
    Gustavo Petro 3195623143
    Gustavo Petro 460104479
    Gustavo Petro 22386555
    Gustavo Petro 267987206
    Gustavo Petro 3383520340
    Gustavo Petro 24010471
    Gustavo Petro 45739032
    Gustavo Petro 1380667435
    Gustavo Petro 552221781
    Gustavo Petro 296769278
    Gustavo Petro 285680316
    Gustavo Petro 52819651
    Gustavo Petro 415718498
    Gustavo Petro 3366165322
    Gustavo Petro 2470352757
    Gustavo Petro 3158509274
    Gustavo Petro 486895655
    Gustavo Petro 26946244
    Gustavo Petro 87227411
    Gustavo Petro 27391585
    Gustavo Petro 2611907436
    Gustavo Petro 2249440891
    Gustavo Petro 229043036
    Gustavo Petro 2292454922
    Gustavo Petro 47285504
    Gustavo Petro 70385068
    Gustavo Petro 232388741
    Gustavo Petro 3246389309
    Gustavo Petro 143185079
    Gustavo Petro 152010594
    Gustavo Petro 16106724
    Gustavo Petro 949761751
    Gustavo Petro 382177285
    Gustavo Petro 705484506
    Gustavo Petro 3088563629
    Gustavo Petro 3264396165
    Gustavo Petro 2646621936
    Gustavo Petro 1615253756
    Gustavo Petro 143285665
    Gustavo Petro 82978962
    Gustavo Petro 2297757072
    Gustavo Petro 3325713508
    Gustavo Petro 46831967
    Gustavo Petro 322518423
    Gustavo Petro 1280230315
    Gustavo Petro 237972063
    Gustavo Petro 169100950
    Gustavo Petro 2717835254
    Gustavo Petro 58599566
    Gustavo Petro 3091278735
    Gustavo Petro 3178649582
    Gustavo Petro 72519424
    Gustavo Petro 191116431
    Gustavo Petro 1062945685
    Gustavo Petro 3091376321
    Gustavo Petro 102095809
    Gustavo Petro 208903718
    Gustavo Petro 3078381021
    Gustavo Petro 3105251734
    Gustavo Petro 146645636
    Gustavo Petro 122530299
    Gustavo Petro 359550367
    Gustavo Petro 2335368354
    Gustavo Petro 19527964
    Gustavo Petro 285255977
    Gustavo Petro 294372356
    Gustavo Petro 1123654224
    Gustavo Petro 25493114
    Gustavo Petro 749474222
    Gustavo Petro 3132865064
    Gustavo Petro 1213244702
    Gustavo Petro 603232368
    Gustavo Petro 2409440906
    Gustavo Petro 96929235
    Gustavo Petro 1686097045
    Gustavo Petro 61243172
    Gustavo Petro 3028829008
    Gustavo Petro 335615080
    Gustavo Petro 115476363
    Gustavo Petro 148337854
    Gustavo Petro 3060302850
    Gustavo Petro 207680236
    Gustavo Petro 3013953477
    Gustavo Petro 194268348
    Gustavo Petro 121817564
    Gustavo Petro 100066673
    Gustavo Petro 1720868641
    Gustavo Petro 24919888
    Gustavo Petro 244730854
    Gustavo Petro 343043491
    Gustavo Petro 335369838
    Gustavo Petro 21919812
    Gustavo Petro 17560195
    Gustavo Petro 14955620
    Gustavo Petro 331803536
    Gustavo Petro 16313140
    Gustavo Petro 99625216
    Gustavo Petro 18928144
    Gustavo Petro 19881931
    Gustavo Petro 21201942
    Gustavo Petro 26203847
    Gustavo Petro 27288119
    Gustavo Petro 15557246
    Gustavo Petro 309278028
    Gustavo Petro 84944278
    Gustavo Petro 4157261
    Gustavo Petro 158059666
    Gustavo Petro 396175695
    Gustavo Petro 3023463639
    Gustavo Petro 113080978
    Gustavo Petro 626758812
    Gustavo Petro 1042858094
    Gustavo Petro 86201320
    Gustavo Petro 614540333
    Gustavo Petro 614526059
    Gustavo Petro 219172013
    Gustavo Petro 615366762
    Gustavo Petro 471941392
    Gustavo Petro 615265979
    Gustavo Petro 615357492
    Gustavo Petro 615354543
    Gustavo Petro 322011448
    Gustavo Petro 615283960
    Gustavo Petro 615281135
    Gustavo Petro 626808393
    Gustavo Petro 615268721
    Gustavo Petro 114579672
    Gustavo Petro 806598084
    Gustavo Petro 586291040
    Gustavo Petro 365561215
    Gustavo Petro 614529023
    Gustavo Petro 364761686
    Gustavo Petro 2872227592
    Gustavo Petro 77219495
    Gustavo Petro 337886919
    Gustavo Petro 234137101
    Gustavo Petro 290672220
    Gustavo Petro 2301937524
    Gustavo Petro 438035525
    Gustavo Petro 68440549
    Gustavo Petro 234334894
    Gustavo Petro 1101515659
    Gustavo Petro 65416867
    Gustavo Petro 822910567
    Gustavo Petro 260427586
    Gustavo Petro 1346187043
    Gustavo Petro 1682833878
    Gustavo Petro 2841634906
    Gustavo Petro 146649217
    Gustavo Petro 243624110
    Gustavo Petro 57174405
    Gustavo Petro 1110458767
    Gustavo Petro 170254080
    Gustavo Petro 169222815
    Gustavo Petro 278854191
    Gustavo Petro 396192327
    Gustavo Petro 2801175694
    Gustavo Petro 2886445529
    Gustavo Petro 243162090
    Gustavo Petro 2583181743
    Gustavo Petro 2217130004
    Gustavo Petro 178382014
    Gustavo Petro 2806584965
    Gustavo Petro 1391162509
    Gustavo Petro 143141524
    Gustavo Petro 475489471
    Gustavo Petro 21622792
    Gustavo Petro 861525596
    Gustavo Petro 86794842
    Gustavo Petro 259823635
    Gustavo Petro 572063520
    Gustavo Petro 2529396806
    Gustavo Petro 1169971248
    Gustavo Petro 1319304234
    Gustavo Petro 108670198
    Gustavo Petro 1570862006
    Gustavo Petro 2415303800
    Gustavo Petro 294334147
    Gustavo Petro 46271480
    Gustavo Petro 2559465857
    Gustavo Petro 2846242097
    Gustavo Petro 433564921
    Gustavo Petro 2315823594
    Gustavo Petro 39522911
    Gustavo Petro 1017149809
    Gustavo Petro 618011830
    Gustavo Petro 2755430545
    Gustavo Petro 480466425
    Gustavo Petro 539359886
    Gustavo Petro 208451321
    Gustavo Petro 2386649556
    Gustavo Petro 19834403
    Gustavo Petro 337783129
    Gustavo Petro 2557445252
    Gustavo Petro 2553151
    Gustavo Petro 2596694492
    Gustavo Petro 520968443
    Gustavo Petro 252317583
    Gustavo Petro 2811390026
    Gustavo Petro 818857692
    Gustavo Petro 156054318
    Gustavo Petro 2202498345
    Gustavo Petro 2786448457
    Gustavo Petro 34798360
    Gustavo Petro 2548854433
    Gustavo Petro 130599784
    Gustavo Petro 32448272
    Gustavo Petro 246484328
    Gustavo Petro 100006904
    Gustavo Petro 520690173
    Gustavo Petro 1423824241
    Gustavo Petro 1368563930
    Gustavo Petro 1009556227
    Gustavo Petro 1151376356
    Gustavo Petro 2411189576
    Gustavo Petro 1201567172
    Gustavo Petro 231899420
    Gustavo Petro 339715629
    Gustavo Petro 89707185
    Gustavo Petro 474213039
    Gustavo Petro 261418327
    Gustavo Petro 279336385
    Gustavo Petro 106498022
    Gustavo Petro 742993460
    Gustavo Petro 593944030
    Gustavo Petro 2707339330
    Gustavo Petro 111250814
    Gustavo Petro 121859642
    Gustavo Petro 33203801
    Gustavo Petro 346151846
    Gustavo Petro 61356444
    Gustavo Petro 274087824
    Gustavo Petro 66740100
    Gustavo Petro 2574839353
    Gustavo Petro 2247945474
    Gustavo Petro 2560021844
    Gustavo Petro 2308504212
    Gustavo Petro 186876893
    Gustavo Petro 130308100
    Gustavo Petro 2288138575
    Gustavo Petro 1663881138
    Gustavo Petro 165602277
    Gustavo Petro 386520966
    Gustavo Petro 107772008
    Gustavo Petro 174027585
    Gustavo Petro 2470183729
    Gustavo Petro 216457140
    Gustavo Petro 59810501
    Gustavo Petro 115262612
    Gustavo Petro 553621800
    Gustavo Petro 150786617
    Gustavo Petro 574252317
    Gustavo Petro 1604494958
    Gustavo Petro 416514293
    Gustavo Petro 127588840
    Gustavo Petro 459703392
    Gustavo Petro 1582987716
    Gustavo Petro 1368273666
    Gustavo Petro 456216994
    Gustavo Petro 388008943
    Gustavo Petro 165184441
    Gustavo Petro 485985425
    Gustavo Petro 319927466
    Gustavo Petro 1491363217
    Gustavo Petro 187042474
    Gustavo Petro 237445795
    Gustavo Petro 189209897
    Gustavo Petro 1440216992
    Gustavo Petro 1096011415
    Gustavo Petro 838532454
    Gustavo Petro 256774894
    Gustavo Petro 1706026952
    Gustavo Petro 1694766042
    Gustavo Petro 535472183
    Gustavo Petro 140982720
    Gustavo Petro 1107553495
    Gustavo Petro 447400443
    Gustavo Petro 234813150
    Gustavo Petro 2177451673
    Gustavo Petro 339418443
    Gustavo Petro 424386209
    Gustavo Petro 1267204351
    Gustavo Petro 272757442
    Gustavo Petro 114511956
    Gustavo Petro 296863250
    Gustavo Petro 139761183
    Gustavo Petro 2343319630
    Gustavo Petro 51069819
    Gustavo Petro 103942594
    Gustavo Petro 2306958854
    Gustavo Petro 255299017
    Gustavo Petro 1241584285
    Gustavo Petro 25645206
    Gustavo Petro 243236419
    Gustavo Petro 359510581
    Gustavo Petro 995982924
    Gustavo Petro 584950438
    Gustavo Petro 2322760729
    Gustavo Petro 2254456303
    Gustavo Petro 321152468
    Gustavo Petro 75884054
    Gustavo Petro 379537840
    Gustavo Petro 83298668
    Gustavo Petro 376445776
    Gustavo Petro 202601039
    Gustavo Petro 431660537
    Gustavo Petro 281731492
    Gustavo Petro 362814353
    Gustavo Petro 300518510
    Gustavo Petro 330105173
    Gustavo Petro 1396962980
    Gustavo Petro 423096569
    Gustavo Petro 803934619
    Gustavo Petro 70734968
    Gustavo Petro 193040838
    Gustavo Petro 270671714
    Gustavo Petro 636427402
    Gustavo Petro 41380936
    Gustavo Petro 338073743
    Gustavo Petro 567325528
    Gustavo Petro 312999344
    Gustavo Petro 310073944
    Gustavo Petro 395050894
    Gustavo Petro 79258256
    Gustavo Petro 140634413
    Gustavo Petro 339261408
    Gustavo Petro 173791558
    Gustavo Petro 383752490
    Gustavo Petro 16228699
    Gustavo Petro 271365891
    Gustavo Petro 233747266
    Gustavo Petro 135668299
    Gustavo Petro 136263204
    Gustavo Petro 360614850
    Gustavo Petro 106297032
    Gustavo Petro 253900011
    Gustavo Petro 189916128
    Gustavo Petro 246363251
    Gustavo Petro 150375824
    Gustavo Petro 129688630
    Gustavo Petro 1011630535
    Gustavo Petro 437297114
    Gustavo Petro 467434207
    Gustavo Petro 298163347
    Gustavo Petro 444864072
    Gustavo Petro 69101111
    Gustavo Petro 177418493
    Gustavo Petro 14634720
    Gustavo Petro 3554721
    Gustavo Petro 1556449070
    Gustavo Petro 300518361
    Gustavo Petro 95517630
    Gustavo Petro 45577446
    Gustavo Petro 523514012
    Gustavo Petro 789434989
    Gustavo Petro 256277109
    Gustavo Petro 495539242
    Gustavo Petro 79603494
    Gustavo Petro 145791429
    Gustavo Petro 212383558
    Gustavo Petro 471925595
    Gustavo Petro 498299944
    Gustavo Petro 1370927040
    Gustavo Petro 186197464
    Gustavo Petro 525264466
    Gustavo Petro 533433289
    Gustavo Petro 42172973
    Gustavo Petro 116962530
    Gustavo Petro 289506642
    Gustavo Petro 282762116
    Gustavo Petro 45730528
    Gustavo Petro 1350404346
    Gustavo Petro 768540085
    Gustavo Petro 570539613
    Gustavo Petro 272024031
    Gustavo Petro 1195171315
    Gustavo Petro 562251963
    Gustavo Petro 160786800
    Gustavo Petro 964933740
    Gustavo Petro 284544447
    Gustavo Petro 815911244
    Gustavo Petro 1483758774
    Gustavo Petro 164445142
    Gustavo Petro 224830527
    Gustavo Petro 991671721
    Gustavo Petro 1116938814
    Gustavo Petro 83917616
    Gustavo Petro 47858163
    Gustavo Petro 21866534
    Gustavo Petro 242425204
    Gustavo Petro 794087970
    Gustavo Petro 1473677593
    Gustavo Petro 113451138
    Gustavo Petro 283249568
    Gustavo Petro 612908244
    Gustavo Petro 1455449840
    Gustavo Petro 153012287
    Gustavo Petro 1201324818
    Gustavo Petro 14196062
    Gustavo Petro 1031350722
    Gustavo Petro 140914625
    Gustavo Petro 101486124
    Gustavo Petro 216557724
    Gustavo Petro 331053274
    Gustavo Petro 348218292
    Gustavo Petro 193533203
    Gustavo Petro 132229611
    Gustavo Petro 223927133
    Gustavo Petro 118125638
    Gustavo Petro 1341782942
    Gustavo Petro 338614473
    Gustavo Petro 20560294
    Gustavo Petro 711429691
    Gustavo Petro 1350107358
    Gustavo Petro 418851119
    Gustavo Petro 372015524
    Gustavo Petro 256319425
    Gustavo Petro 373546878
    Gustavo Petro 398765291
    Gustavo Petro 542104590
    Gustavo Petro 1205954378
    Gustavo Petro 395660312
    Gustavo Petro 12548672
    Gustavo Petro 211679970
    Gustavo Petro 163915378
    Gustavo Petro 1098808974
    Gustavo Petro 63198274
    Gustavo Petro 1240238065
    Gustavo Petro 1126785620
    Gustavo Petro 128039798
    Gustavo Petro 92808614
    Gustavo Petro 937373635
    Gustavo Petro 863126688
    Gustavo Petro 526973835
    Gustavo Petro 373652449
    Gustavo Petro 1252764865
    Gustavo Petro 156323995
    Gustavo Petro 624995677
    Gustavo Petro 146204096
    Gustavo Petro 247379224
    Gustavo Petro 128637520
    Gustavo Petro 206689693
    Gustavo Petro 260438790
    Gustavo Petro 128262354
    Gustavo Petro 714672510
    Gustavo Petro 115143478
    Gustavo Petro 102094084
    Gustavo Petro 342363193
    Gustavo Petro 261481927
    Gustavo Petro 19275255
    Gustavo Petro 111356236
    Gustavo Petro 22428439
    Gustavo Petro 346340484
    Gustavo Petro 218298803
    Gustavo Petro 753718070
    Gustavo Petro 394268768
    

    Rate limit reached. Sleeping for: 712
    

    Gustavo Petro 184590625
    Gustavo Petro 157034349
    Gustavo Petro 963229003
    Gustavo Petro 15409880
    Gustavo Petro 453674449
    Gustavo Petro 142745406
    Gustavo Petro 54906529
    Gustavo Petro 1122253099
    Gustavo Petro 90974409
    Gustavo Petro 224400256
    Gustavo Petro 78442816
    Gustavo Petro 39313353
    Gustavo Petro 493388844
    Gustavo Petro 194351345
    Gustavo Petro 56713330
    Gustavo Petro 179137892
    Gustavo Petro 478024475
    Gustavo Petro 257751379
    Gustavo Petro 564221825
    Gustavo Petro 436342741
    Gustavo Petro 276657033
    Gustavo Petro 207140975
    Gustavo Petro 240409671
    Gustavo Petro 76941349
    Gustavo Petro 248453259
    Gustavo Petro 39657191
    Gustavo Petro 271649023
    Gustavo Petro 37758638
    Gustavo Petro 58038456
    Gustavo Petro 233547379
    Gustavo Petro 858741475
    Gustavo Petro 24516380
    Gustavo Petro 67512424
    Gustavo Petro 556121251
    Gustavo Petro 149983213
    Gustavo Petro 346543727
    Gustavo Petro 607856488
    Gustavo Petro 309148363
    Gustavo Petro 863071850
    Gustavo Petro 553137750
    Gustavo Petro 143606072
    Gustavo Petro 55857584
    Gustavo Petro 477767215
    Gustavo Petro 883360010
    Gustavo Petro 91796121
    Gustavo Petro 356785911
    Gustavo Petro 180837635
    Gustavo Petro 110010608
    Gustavo Petro 109981413
    Gustavo Petro 87705847
    Gustavo Petro 160943043
    Gustavo Petro 334932240
    Gustavo Petro 20987390
    Gustavo Petro 300601375
    Gustavo Petro 511212488
    Gustavo Petro 270061117
    Gustavo Petro 817637365
    Gustavo Petro 68861723
    Gustavo Petro 27623679
    Gustavo Petro 314472089
    Gustavo Petro 326918491
    Gustavo Petro 21860431
    Gustavo Petro 104837801
    Gustavo Petro 76039148
    Gustavo Petro 179584524
    Gustavo Petro 174243123
    Gustavo Petro 142411344
    Gustavo Petro 134830584
    Gustavo Petro 109458073
    Gustavo Petro 212325264
    Gustavo Petro 82435929
    Gustavo Petro 458841921
    Gustavo Petro 31162623
    Gustavo Petro 60161414
    Gustavo Petro 51918727
    Gustavo Petro 312760235
    Gustavo Petro 80936145
    Gustavo Petro 227884460
    Gustavo Petro 601144384
    Gustavo Petro 178401782
    Gustavo Petro 306044550
    Gustavo Petro 820794872
    Gustavo Petro 382429676
    Gustavo Petro 428525640
    Gustavo Petro 499825880
    Gustavo Petro 490869020
    Gustavo Petro 356658203
    Gustavo Petro 717293401
    Gustavo Petro 505903840
    Gustavo Petro 98046615
    Gustavo Petro 226426927
    Gustavo Petro 49681553
    Gustavo Petro 174361486
    Gustavo Petro 238935994
    Gustavo Petro 156408607
    Gustavo Petro 138153985
    Gustavo Petro 140477439
    Gustavo Petro 181741000
    Gustavo Petro 182763517
    Gustavo Petro 757237699
    Gustavo Petro 594067933
    Gustavo Petro 127272026
    Gustavo Petro 296819666
    Gustavo Petro 251774200
    Gustavo Petro 154670681
    Gustavo Petro 142569044
    Gustavo Petro 279646438
    Gustavo Petro 803605580
    Gustavo Petro 322875137
    Gustavo Petro 142820741
    Gustavo Petro 275703505
    Gustavo Petro 107399407
    Gustavo Petro 241135651
    Gustavo Petro 229316937
    Gustavo Petro 162823435
    Gustavo Petro 265592264
    Gustavo Petro 64491444
    Gustavo Petro 88535830
    Gustavo Petro 78982104
    Gustavo Petro 747169903
    Gustavo Petro 556613674
    Gustavo Petro 142414938
    Gustavo Petro 249283549
    Gustavo Petro 271101892
    Gustavo Petro 391446379
    Gustavo Petro 151088536
    Gustavo Petro 343638137
    Gustavo Petro 169468328
    Gustavo Petro 71291628
    Gustavo Petro 134818906
    Gustavo Petro 110017871
    Gustavo Petro 553503926
    Gustavo Petro 143489597
    Gustavo Petro 260297514
    Gustavo Petro 101070665
    Gustavo Petro 31421025
    Gustavo Petro 106751526
    Gustavo Petro 305876654
    Gustavo Petro 515580381
    Gustavo Petro 138814032
    Gustavo Petro 551970102
    Gustavo Petro 46220806
    Gustavo Petro 178553051
    Gustavo Petro 150936441
    Gustavo Petro 602439443
    Gustavo Petro 505270457
    Gustavo Petro 415735580
    Gustavo Petro 247299618
    Gustavo Petro 114873372
    Gustavo Petro 59916044
    Gustavo Petro 148763813
    Gustavo Petro 211047525
    Gustavo Petro 338358478
    Gustavo Petro 487947174
    Gustavo Petro 147589738
    Gustavo Petro 553705689
    Gustavo Petro 138686927
    Gustavo Petro 124625661
    Gustavo Petro 486175415
    Gustavo Petro 569223427
    Gustavo Petro 544643751
    Gustavo Petro 103056834
    Gustavo Petro 346323375
    Gustavo Petro 572842421
    Gustavo Petro 64763600
    Gustavo Petro 128657300
    Gustavo Petro 356373712
    Gustavo Petro 378086932
    Gustavo Petro 195820318
    Gustavo Petro 549389972
    Gustavo Petro 94803860
    Gustavo Petro 58295363
    Gustavo Petro 195905174
    Gustavo Petro 306592243
    Gustavo Petro 203145015
    Gustavo Petro 164424747
    Gustavo Petro 180637474
    Gustavo Petro 322799333
    Gustavo Petro 528834872
    Gustavo Petro 446652436
    Gustavo Petro 83946902
    Gustavo Petro 168520576
    Gustavo Petro 207247994
    Gustavo Petro 396212807
    Gustavo Petro 546259657
    Gustavo Petro 529865703
    Gustavo Petro 539569550
    Gustavo Petro 364362035
    Gustavo Petro 446671283
    Gustavo Petro 158484588
    Gustavo Petro 69731251
    Gustavo Petro 64798737
    Gustavo Petro 144376833
    Gustavo Petro 34586817
    Gustavo Petro 147305792
    Gustavo Petro 238919402
    Gustavo Petro 153129999
    Gustavo Petro 107530451
    Gustavo Petro 382880553
    Gustavo Petro 515461048
    Gustavo Petro 297410864
    Gustavo Petro 170876875
    Gustavo Petro 376539098
    Gustavo Petro 85905016
    Gustavo Petro 59109178
    Gustavo Petro 380608439
    Gustavo Petro 108717093
    Gustavo Petro 150406687
    Gustavo Petro 17676713
    Gustavo Petro 148545421
    Gustavo Petro 158843124
    Gustavo Petro 270949527
    Gustavo Petro 372626950
    Gustavo Petro 260757234
    Gustavo Petro 368392630
    Gustavo Petro 134578155
    Gustavo Petro 357742543
    Gustavo Petro 250265046
    Gustavo Petro 417103282
    Gustavo Petro 357229041
    Gustavo Petro 69683409
    Gustavo Petro 339890319
    Gustavo Petro 191998431
    Gustavo Petro 56136736
    Gustavo Petro 57428870
    Gustavo Petro 252134272
    Gustavo Petro 62286537
    Gustavo Petro 139273919
    Gustavo Petro 87781992
    Gustavo Petro 451493601
    Gustavo Petro 314552752
    Gustavo Petro 238747644
    Gustavo Petro 162933932
    Gustavo Petro 424312509
    Gustavo Petro 97062997
    Gustavo Petro 53781570
    Gustavo Petro 201572956
    Gustavo Petro 112764971
    Gustavo Petro 83746659
    Gustavo Petro 465719121
    Gustavo Petro 62528273
    Gustavo Petro 216592687
    Gustavo Petro 371250630
    Gustavo Petro 89796388
    Gustavo Petro 268052123
    Gustavo Petro 178718239
    Gustavo Petro 321616253
    Gustavo Petro 62442788
    Gustavo Petro 119431745
    Gustavo Petro 108711532
    Gustavo Petro 45866793
    Gustavo Petro 177777956
    Gustavo Petro 271414654
    Gustavo Petro 23187207
    Gustavo Petro 446324242
    Gustavo Petro 249360165
    Gustavo Petro 116061492
    Gustavo Petro 248553937
    Gustavo Petro 62857009
    Gustavo Petro 142465457
    Gustavo Petro 290632907
    Gustavo Petro 168297213
    Gustavo Petro 189996423
    Gustavo Petro 55355913
    Gustavo Petro 339153279
    Gustavo Petro 66639420
    Gustavo Petro 394948948
    Gustavo Petro 395314853
    Gustavo Petro 395339416
    Gustavo Petro 394950798
    Gustavo Petro 394957444
    Gustavo Petro 395316218
    Gustavo Petro 395375605
    Gustavo Petro 395335071
    Gustavo Petro 395471476
    Gustavo Petro 395478869
    Gustavo Petro 395408106
    Gustavo Petro 395460279
    Gustavo Petro 395502585
    Gustavo Petro 395505034
    Gustavo Petro 395370803
    Gustavo Petro 395351321
    Gustavo Petro 394960335
    Gustavo Petro 395341479
    Gustavo Petro 395345550
    Gustavo Petro 174443391
    Gustavo Petro 262990777
    Gustavo Petro 173629386
    Gustavo Petro 42504123
    Gustavo Petro 340412250
    Gustavo Petro 165452596
    Gustavo Petro 155112191
    Gustavo Petro 364258919
    Gustavo Petro 138456839
    Gustavo Petro 371330206
    Gustavo Petro 221220530
    Gustavo Petro 311155499
    Gustavo Petro 218479107
    Gustavo Petro 230944555
    Gustavo Petro 314203772
    Gustavo Petro 371233512
    Gustavo Petro 94238008
    Gustavo Petro 83385283
    Gustavo Petro 366829662
    Gustavo Petro 364481104
    Gustavo Petro 83491226
    Gustavo Petro 258532102
    Gustavo Petro 156506617
    Gustavo Petro 85089635
    Gustavo Petro 255604888
    Gustavo Petro 161180797
    Gustavo Petro 346747666
    Gustavo Petro 363429606
    Gustavo Petro 223625651
    Gustavo Petro 127973382
    Gustavo Petro 368013555
    Gustavo Petro 337397678
    Gustavo Petro 77060783
    Gustavo Petro 373000861
    Gustavo Petro 353160941
    Gustavo Petro 140289698
    Gustavo Petro 366673109
    Gustavo Petro 179240407
    Gustavo Petro 358203471
    Gustavo Petro 299858726
    Gustavo Petro 373069649
    Gustavo Petro 165548534
    Gustavo Petro 367510125
    Gustavo Petro 373082346
    Gustavo Petro 373086359
    Gustavo Petro 373085370
    Gustavo Petro 283207143
    Gustavo Petro 372948890
    Gustavo Petro 352799018
    Gustavo Petro 302110831
    Gustavo Petro 373068123
    Gustavo Petro 287977652
    Gustavo Petro 258598446
    Gustavo Petro 373095172
    Gustavo Petro 367441830
    Gustavo Petro 373120244
    Gustavo Petro 373119671
    Gustavo Petro 105026262
    Gustavo Petro 163480899
    Gustavo Petro 242813459
    Gustavo Petro 159665189
    Gustavo Petro 373128306
    Gustavo Petro 89106192
    Gustavo Petro 356520886
    Gustavo Petro 290820489
    Gustavo Petro 319375681
    Gustavo Petro 361775930
    Gustavo Petro 266999427
    Gustavo Petro 373133925
    Gustavo Petro 117449250
    Gustavo Petro 373061832
    Gustavo Petro 266809807
    Gustavo Petro 356277032
    Gustavo Petro 373138480
    Gustavo Petro 373141320
    Gustavo Petro 167107764
    Gustavo Petro 157048085
    Gustavo Petro 311162734
    Gustavo Petro 58113062
    Gustavo Petro 128917152
    Gustavo Petro 56721450
    Gustavo Petro 312144062
    Gustavo Petro 367514615
    Gustavo Petro 339413810
    Gustavo Petro 373150946
    Gustavo Petro 189732111
    Gustavo Petro 152271805
    Gustavo Petro 197653760
    Gustavo Petro 87535858
    Gustavo Petro 271698603
    Gustavo Petro 356690398
    Gustavo Petro 195998710
    Gustavo Petro 349853964
    Gustavo Petro 110492939
    Gustavo Petro 154657147
    Gustavo Petro 196209794
    Gustavo Petro 361861572
    Gustavo Petro 289146647
    Gustavo Petro 345093641
    Gustavo Petro 370664179
    Gustavo Petro 243942199
    Gustavo Petro 217626580
    Gustavo Petro 373187450
    Gustavo Petro 256823060
    Gustavo Petro 12206882
    Gustavo Petro 373196630
    Gustavo Petro 218572606
    Gustavo Petro 83525488
    Gustavo Petro 373177930
    Gustavo Petro 51096139
    Gustavo Petro 149325913
    Gustavo Petro 323291982
    Gustavo Petro 310498630
    Gustavo Petro 82531725
    Gustavo Petro 67345614
    Gustavo Petro 139073341
    Gustavo Petro 192611966
    Gustavo Petro 264270324
    Gustavo Petro 373281011
    Gustavo Petro 356516006
    Gustavo Petro 57217264
    Gustavo Petro 130673233
    Gustavo Petro 149127737
    Gustavo Petro 193001822
    Gustavo Petro 296035965
    Gustavo Petro 373362059
    Gustavo Petro 365063353
    Gustavo Petro 99188504
    Gustavo Petro 57790999
    Gustavo Petro 371066957
    Gustavo Petro 107567905
    Gustavo Petro 327018499
    Gustavo Petro 373378223
    Gustavo Petro 373049341
    Gustavo Petro 318486838
    Gustavo Petro 240402139
    Gustavo Petro 247859215
    Gustavo Petro 58977931
    Gustavo Petro 348447373
    Gustavo Petro 109845886
    Gustavo Petro 276190553
    Gustavo Petro 69693104
    Gustavo Petro 233940616
    Gustavo Petro 123903962
    Gustavo Petro 318663671
    Gustavo Petro 373354585
    Gustavo Petro 370304954
    Gustavo Petro 22181741
    Gustavo Petro 113753541
    Gustavo Petro 136030168
    Gustavo Petro 369896643
    Gustavo Petro 320553246
    Gustavo Petro 91374064
    Gustavo Petro 354371131
    Gustavo Petro 68816714
    Gustavo Petro 294112072
    Gustavo Petro 298139835
    Gustavo Petro 279859267
    Gustavo Petro 323549487
    Gustavo Petro 213418250
    Gustavo Petro 335255628
    Gustavo Petro 31285861
    Gustavo Petro 316577392
    Gustavo Petro 252838418
    Gustavo Petro 109556698
    Gustavo Petro 128257158
    Gustavo Petro 126753797
    Gustavo Petro 95299420
    Gustavo Petro 220095777
    Gustavo Petro 159502687
    Gustavo Petro 147250304
    Gustavo Petro 260887118
    Gustavo Petro 302084015
    Gustavo Petro 65824317
    Gustavo Petro 259215394
    Gustavo Petro 46657344
    Gustavo Petro 292400781
    Gustavo Petro 138604213
    Gustavo Petro 132545958
    Gustavo Petro 171113489
    Gustavo Petro 270585208
    Gustavo Petro 149628328
    Gustavo Petro 319476751
    Gustavo Petro 208126299
    Gustavo Petro 373427853
    Gustavo Petro 298291743
    Gustavo Petro 372461767
    Gustavo Petro 290799770
    Gustavo Petro 196637584
    Gustavo Petro 132953948
    Gustavo Petro 153104676
    Gustavo Petro 197661556
    Gustavo Petro 356319833
    Gustavo Petro 54457247
    Gustavo Petro 349104125
    Gustavo Petro 317272758
    Gustavo Petro 310497724
    Gustavo Petro 372934164
    Gustavo Petro 308192905
    Gustavo Petro 97431852
    Gustavo Petro 42632574
    Gustavo Petro 171512339
    Gustavo Petro 357610731
    Gustavo Petro 368981026
    Gustavo Petro 334438642
    Gustavo Petro 346075755
    Gustavo Petro 245428025
    Gustavo Petro 368640238
    Gustavo Petro 372882136
    Gustavo Petro 95493646
    Gustavo Petro 332521817
    Gustavo Petro 306853513
    Gustavo Petro 111480631
    Gustavo Petro 148951458
    Gustavo Petro 373397815
    Gustavo Petro 372743416
    Gustavo Petro 334254134
    Gustavo Petro 310834692
    Gustavo Petro 312309557
    Gustavo Petro 114286655
    Gustavo Petro 370669749
    Gustavo Petro 221356450
    Gustavo Petro 102493314
    Gustavo Petro 275669180
    Gustavo Petro 69186323
    Gustavo Petro 283240639
    Gustavo Petro 340946513
    Gustavo Petro 373507182
    Gustavo Petro 200934215
    Gustavo Petro 373514323
    Gustavo Petro 373515268
    Gustavo Petro 51232132
    Gustavo Petro 127956130
    Gustavo Petro 364442769
    Gustavo Petro 371197296
    Gustavo Petro 280212334
    Gustavo Petro 373534159
    Gustavo Petro 336219118
    Gustavo Petro 67168135
    Gustavo Petro 254861372
    Gustavo Petro 373554682
    Gustavo Petro 369107105
    Gustavo Petro 282130397
    Gustavo Petro 373563376
    Gustavo Petro 184060412
    Gustavo Petro 337436626
    Gustavo Petro 372246142
    Gustavo Petro 302191134
    Gustavo Petro 178452914
    Gustavo Petro 348133785
    Gustavo Petro 46507406
    Gustavo Petro 251425717
    Gustavo Petro 244243171
    Gustavo Petro 364420218
    Gustavo Petro 351786797
    Gustavo Petro 161939319
    Gustavo Petro 77783753
    Gustavo Petro 222001138
    Gustavo Petro 129352315
    Gustavo Petro 359016953
    Gustavo Petro 355698712
    Gustavo Petro 259855457
    Gustavo Petro 362558964
    Gustavo Petro 360796473
    Gustavo Petro 371971185
    Gustavo Petro 160089291
    Gustavo Petro 358178325
    Gustavo Petro 371014349
    Gustavo Petro 228203945
    Gustavo Petro 249260659
    Gustavo Petro 363308743
    Gustavo Petro 373591488
    Gustavo Petro 63111815
    Gustavo Petro 361755908
    Gustavo Petro 53837782
    Gustavo Petro 188347743
    Gustavo Petro 132685353
    Gustavo Petro 242755483
    Gustavo Petro 363418191
    Gustavo Petro 47963334
    Gustavo Petro 65229994
    Gustavo Petro 44709800
    Gustavo Petro 62328908
    Gustavo Petro 367767151
    Gustavo Petro 362012484
    Gustavo Petro 365121895
    Gustavo Petro 364298224
    Gustavo Petro 364305600
    Gustavo Petro 209780362
    Gustavo Petro 352684026
    Gustavo Petro 342953274
    Gustavo Petro 359548222
    Gustavo Petro 127912366
    Gustavo Petro 202325462
    Gustavo Petro 104667944
    Gustavo Petro 778057
    Gustavo Petro 64939737
    Gustavo Petro 229620521
    Gustavo Petro 279353642
    Gustavo Petro 181324352
    Gustavo Petro 22635623
    Gustavo Petro 242872027
    Gustavo Petro 212744531
    Gustavo Petro 343931101
    Gustavo Petro 25727186
    Gustavo Petro 151129980
    Gustavo Petro 14265894
    Gustavo Petro 159203021
    Gustavo Petro 204479328
    Gustavo Petro 253938050
    Gustavo Petro 23246440
    Gustavo Petro 38652717
    Gustavo Petro 186952637
    Gustavo Petro 77212084
    Gustavo Petro 285698716
    Gustavo Petro 241113701
    Gustavo Petro 318876882
    Gustavo Petro 20462383
    Gustavo Petro 235304680
    Gustavo Petro 179088849
    Gustavo Petro 39534869
    Gustavo Petro 326671510
    Gustavo Petro 18869165
    Gustavo Petro 202490670
    Gustavo Petro 342672659
    Gustavo Petro 203962721
    Gustavo Petro 15762708
    Gustavo Petro 36497671
    Gustavo Petro 122546989
    Gustavo Petro 110864102
    Gustavo Petro 338985001
    Gustavo Petro 112134350
    Gustavo Petro 103606546
    Gustavo Petro 95230533
    Gustavo Petro 97452391
    Gustavo Petro 98146434
    Gustavo Petro 144371255
    Gustavo Petro 322195451
    Gustavo Petro 54038701
    Gustavo Petro 60328985
    Gustavo Petro 90558638
    Gustavo Petro 198573960
    Gustavo Petro 334921284
    Gustavo Petro 59153434
    Gustavo Petro 40680083
    Gustavo Petro 256194852
    Gustavo Petro 139854980
    Gustavo Petro 333068448
    Gustavo Petro 304793712
    Gustavo Petro 261353903
    Gustavo Petro 238322796
    Gustavo Petro 53285973
    Gustavo Petro 126632402
    Gustavo Petro 325074749
    Gustavo Petro 325827558
    Gustavo Petro 65733178
    Gustavo Petro 155295833
    Gustavo Petro 321765070
    Gustavo Petro 249159731
    Gustavo Petro 262691069
    Gustavo Petro 91915086
    Gustavo Petro 127225115
    Gustavo Petro 126740286
    Gustavo Petro 302372249
    Gustavo Petro 169351250
    Gustavo Petro 164836097
    Gustavo Petro 296986384
    Gustavo Petro 257498123
    Gustavo Petro 300670697
    Gustavo Petro 16777543
    Gustavo Petro 302419343
    Gustavo Petro 64829924
    Gustavo Petro 247850161
    Gustavo Petro 307183564
    Gustavo Petro 41224847
    Gustavo Petro 134855279
    Gustavo Petro 187619355
    Gustavo Petro 192379508
    Gustavo Petro 212844931
    Gustavo Petro 24870470
    Gustavo Petro 306512028
    Gustavo Petro 220877855
    Gustavo Petro 230418770
    Gustavo Petro 301197102
    Gustavo Petro 115188252
    Gustavo Petro 270082523
    Gustavo Petro 82119937
    Gustavo Petro 233473291
    Gustavo Petro 293403781
    Gustavo Petro 267355099
    Gustavo Petro 289449670
    Gustavo Petro 10257922
    Gustavo Petro 10629592
    Gustavo Petro 113203754
    Gustavo Petro 80098333
    Gustavo Petro 203262579
    Gustavo Petro 165748292
    Gustavo Petro 37341338
    Gustavo Petro 243417591
    Gustavo Petro 284703021
    Gustavo Petro 73567053
    Gustavo Petro 55914997
    Gustavo Petro 183272394
    Gustavo Petro 176256591
    Gustavo Petro 266431181
    Gustavo Petro 166126036
    Gustavo Petro 283400706
    Gustavo Petro 184071520
    Gustavo Petro 148563241
    Gustavo Petro 147993143
    Gustavo Petro 14333756
    Gustavo Petro 243680902
    Gustavo Petro 131332187
    Gustavo Petro 202367779
    Gustavo Petro 6342542
    Gustavo Petro 242426145
    Gustavo Petro 68506967
    Gustavo Petro 52756754
    Gustavo Petro 50682051
    Gustavo Petro 188484972
    Gustavo Petro 271908496
    Gustavo Petro 142735771
    Gustavo Petro 261906603
    Gustavo Petro 68755646
    Gustavo Petro 35726000
    Gustavo Petro 156679445
    Gustavo Petro 140196438
    Gustavo Petro 191465222
    Gustavo Petro 69432342
    Gustavo Petro 75715850
    Gustavo Petro 30331417
    Gustavo Petro 130864199
    Gustavo Petro 214197761
    Gustavo Petro 278809613
    Gustavo Petro 119922369
    Gustavo Petro 282622027
    Gustavo Petro 135497175
    Gustavo Petro 14994708
    Gustavo Petro 233001872
    Gustavo Petro 109650225
    Gustavo Petro 233366761
    Gustavo Petro 62165799
    Gustavo Petro 61018481
    Gustavo Petro 132883029
    Gustavo Petro 16399647
    Gustavo Petro 16029780
    Gustavo Petro 95294307
    Gustavo Petro 223585856
    Gustavo Petro 115532094
    Gustavo Petro 208230654
    Gustavo Petro 17681513
    Gustavo Petro 22488241
    Gustavo Petro 154555220
    Gustavo Petro 220754629
    Gustavo Petro 87818409
    Gustavo Petro 183496376
    Gustavo Petro 236427380
    Gustavo Petro 211235703
    Gustavo Petro 147799279
    Gustavo Petro 244659783
    Gustavo Petro 236608963
    Gustavo Petro 9317502
    Gustavo Petro 10246482
    Gustavo Petro 18587171
    Gustavo Petro 244529400
    Gustavo Petro 249429622
    Gustavo Petro 18396299
    Gustavo Petro 153686381
    Gustavo Petro 44219339
    Gustavo Petro 7424642
    Gustavo Petro 15302723
    Gustavo Petro 181613510
    Gustavo Petro 95326483
    Gustavo Petro 248107114
    Gustavo Petro 12456402
    Gustavo Petro 60706242
    Gustavo Petro 138140942
    Gustavo Petro 94485058
    Gustavo Petro 97100000
    Gustavo Petro 14700316
    Gustavo Petro 91181758
    Gustavo Petro 213024104
    Gustavo Petro 260871480
    Gustavo Petro 14438300
    Gustavo Petro 724783
    Gustavo Petro 241233333
    Gustavo Petro 16877513
    Gustavo Petro 24338325
    Gustavo Petro 179962803
    Gustavo Petro 57393353
    Gustavo Petro 261312809
    Gustavo Petro 261672678
    Gustavo Petro 32590851
    Gustavo Petro 83334357
    Gustavo Petro 246855644
    Gustavo Petro 139931746
    Gustavo Petro 153148677
    Gustavo Petro 28220156
    Gustavo Petro 31616538
    Gustavo Petro 57148729
    Gustavo Petro 154294030
    Gustavo Petro 51164886
    Gustavo Petro 133048642
    Gustavo Petro 14159148
    Gustavo Petro 257470661
    Gustavo Petro 201712702
    Gustavo Petro 257964664
    Gustavo Petro 244191468
    Gustavo Petro 20849512
    Gustavo Petro 50661819
    Gustavo Petro 33884545
    Gustavo Petro 186045114
    Gustavo Petro 66499236
    Gustavo Petro 252846137
    Gustavo Petro 221670404
    Gustavo Petro 16492068
    Gustavo Petro 44554692
    Gustavo Petro 219419928
    Gustavo Petro 176395929
    Gustavo Petro 69988809
    Gustavo Petro 38227815
    Gustavo Petro 154399615
    Gustavo Petro 84078498
    Gustavo Petro 112570023
    Gustavo Petro 175864992
    Gustavo Petro 51057890
    Gustavo Petro 18650093
    Gustavo Petro 92993433
    Gustavo Petro 244616510
    Gustavo Petro 26729931
    Gustavo Petro 80301588
    Gustavo Petro 248001840
    Gustavo Petro 129834397
    Gustavo Petro 73435719
    Gustavo Petro 227537629
    Gustavo Petro 16122373
    Gustavo Petro 16672510
    Gustavo Petro 119360445
    Gustavo Petro 18424289
    Gustavo Petro 92546663
    Gustavo Petro 186227903
    Gustavo Petro 37294647
    Gustavo Petro 166507237
    Gustavo Petro 23588075
    Gustavo Petro 115773440
    Gustavo Petro 56385497
    Gustavo Petro 38031169
    Gustavo Petro 74626513
    Gustavo Petro 50981729
    Gustavo Petro 44680893
    Gustavo Petro 51241574
    Gustavo Petro 56477340
    Gustavo Petro 20479813
    Gustavo Petro 78890225
    Gustavo Petro 4970411
    Gustavo Petro 14511951
    Gustavo Petro 14885620
    Gustavo Petro 14266598
    Gustavo Petro 116401494
    Gustavo Petro 3459051
    Gustavo Petro 32412540
    Gustavo Petro 17445739
    Gustavo Petro 27681019
    Gustavo Petro 27894784
    Gustavo Petro 18536997
    Gustavo Petro 17150428
    Gustavo Petro 111416652
    Gustavo Petro 17006157
    Gustavo Petro 120181944
    Gustavo Petro 51111741
    Gustavo Petro 28657802
    Gustavo Petro 18622869
    Gustavo Petro 73416019
    Gustavo Petro 17302024
    Gustavo Petro 22063600
    Gustavo Petro 164304654
    Gustavo Petro 19539716
    Gustavo Petro 33062085
    Gustavo Petro 61249886
    Gustavo Petro 41287144
    Gustavo Petro 14677919
    Gustavo Petro 7157292
    Gustavo Petro 22971125
    Gustavo Petro 15865878
    Gustavo Petro 15472700
    Gustavo Petro 59460397
    Gustavo Petro 132514069
    Gustavo Petro 41126618
    Gustavo Petro 14269768
    Gustavo Petro 71256932
    Gustavo Petro 148529707
    Gustavo Petro 15662761
    Gustavo Petro 149272318
    Gustavo Petro 66382691
    Gustavo Petro 15837654
    Gustavo Petro 22177439
    Gustavo Petro 14089370
    Gustavo Petro 16191902
    Gustavo Petro 34175917
    Gustavo Petro 21023681
    Gustavo Petro 23975060
    Gustavo Petro 19918353
    Gustavo Petro 14606079
    Gustavo Petro 18195997
    Gustavo Petro 21633141
    Gustavo Petro 91378530
    Gustavo Petro 121544946
    Gustavo Petro 146548246
    Gustavo Petro 17423992
    Gustavo Petro 14603515
    Gustavo Petro 25946632
    Gustavo Petro 14620853
    Gustavo Petro 14900407
    Gustavo Petro 18674588
    Gustavo Petro 15902877
    Gustavo Petro 78400205
    

    Rate limit reached. Sleeping for: 699
    

    Gustavo Petro 18089913
    Gustavo Petro 2195241
    Gustavo Petro 15817434
    Gustavo Petro 44404175
    Gustavo Petro 36743910
    Gustavo Petro 4898091
    Gustavo Petro 16469679
    Gustavo Petro 26621424
    Gustavo Petro 189376144
    Gustavo Petro 67654599
    Gustavo Petro 69516296
    Gustavo Petro 132297282
    Gustavo Petro 109997084
    Gustavo Petro 59895590
    Gustavo Petro 121738611
    Gustavo Petro 176858988
    Gustavo Petro 199371286
    Gustavo Petro 7540212
    Gustavo Petro 143265708
    Gustavo Petro 144927419
    Gustavo Petro 15207287
    Gustavo Petro 60954521
    Gustavo Petro 2467791
    Gustavo Petro 19390244
    Gustavo Petro 118434325
    Gustavo Petro 16958346
    Gustavo Petro 95448533
    Gustavo Petro 130628574
    Gustavo Petro 25562002
    Gustavo Petro 15110431
    Gustavo Petro 108488345
    Gustavo Petro 1652541
    Gustavo Petro 77302589
    Gustavo Petro 1147321
    Gustavo Petro 73398465
    Gustavo Petro 38022021
    Gustavo Petro 14834302
    Gustavo Petro 116813943
    Gustavo Petro 807095
    Gustavo Petro 5988062
    Gustavo Petro 9633802
    Gustavo Petro 45013575
    Gustavo Petro 138206058
    Gustavo Petro 181199293
    Gustavo Petro 88547901
    Gustavo Petro 228414520
    Gustavo Petro 174492304
    Gustavo Petro 39683468
    Gustavo Petro 87266285
    Gustavo Petro 53187962
    Gustavo Petro 131574396
    Gustavo Petro 128637475
    Gustavo Petro 86761616
    Gustavo Petro 36087400
    Gustavo Petro 19236074
    Gustavo Petro 52558480
    Gustavo Petro 18786579
    Gustavo Petro 7996082
    Gustavo Petro 6003222
    Gustavo Petro 175806207
    Gustavo Petro 15930883
    Gustavo Petro 137908875
    Gustavo Petro 60093623
    Gustavo Petro 39203045
    Gustavo Petro 50442705
    Gustavo Petro 117777080
    Gustavo Petro 168156777
    Gustavo Petro 16589206
    Gustavo Petro 74201578
    Gustavo Petro 197201052
    Gustavo Petro 77625278
    Gustavo Petro 46136235
    Gustavo Petro 70594101
    Gustavo Petro 131582719
    Gustavo Petro 184618018
    Gustavo Petro 98781946
    Gustavo Petro 51163785
    Gustavo Petro 45986928
    Gustavo Petro 82433502
    Gustavo Petro 98708202
    Gustavo Petro 145863712
    Gustavo Petro 49411494
    Gustavo Petro 54542796
    Gustavo Petro 57107167
    Gustavo Petro 21425125
    Gustavo Petro 111654767
    Gustavo Petro 117800967
    Gustavo Petro 116225060
    Gustavo Petro 72380374
    Gustavo Petro 103520177
    Gustavo Petro 73752804
    Gustavo Petro 79551099
    Gustavo Petro 106640158
    Gustavo Petro 102215881
    Gustavo Petro 61220613
    Gustavo Petro 20776240
    Gustavo Petro 61625410
    Gustavo Petro 22512631
    Gustavo Petro 35013719
    Gustavo Petro 62624175
    Gustavo Petro 61916854
    Gustavo Petro 10253742
    Gustavo Petro 56599191
    Gustavo Petro 54421652
    Gustavo Petro 57692747
    Gustavo Petro 57045270
    Gustavo Petro 15066679
    Gustavo Petro 59211923
    Gustavo Petro 25185308
    Gustavo Petro 14474239
    Gustavo Petro 9252212
    Gustavo Petro 17572957
    Gustavo Petro 17295800
    Gustavo Petro 27849097
    Gustavo Petro 38508530
    Gustavo Petro 55127114
    Gustavo Petro 50181947
    Gustavo Petro 56805075
    Gustavo Petro 55723736
    Gustavo Petro 47402728
    Gustavo Petro 38927440
    Gustavo Petro 24376343
    Gustavo Petro 35412479
    Gustavo Petro 18724193
    Gustavo Petro 34965351
    Gustavo Petro 15311907
    Gustavo Petro 29989435
    Gustavo Petro 38026421
    Gustavo Petro 29607462
    Gustavo Petro 15353297
    Gustavo Petro 15997828
    Gustavo Petro 14154757
    Gustavo Petro 29596009
    Gustavo Petro 15114233
    Gustavo Petro 15239537
    Gustavo Petro 17617530
    Gustavo Petro 17220934
    Gustavo Petro 43758060
    Gustavo Petro 44718252
    Gustavo Petro 37814671
    Gustavo Petro 24964484
    Gustavo Petro 13332712
    Ivan Duque Marquez 192010313
    Ivan Duque Marquez 982072241306329089
    Ivan Duque Marquez 126440093
    Ivan Duque Marquez 605854007
    Ivan Duque Marquez 215412304
    Ivan Duque Marquez 770759184
    Ivan Duque Marquez 69323444
    Ivan Duque Marquez 176852177
    Ivan Duque Marquez 63773715
    Ivan Duque Marquez 42473217
    Ivan Duque Marquez 39823635
    Ivan Duque Marquez 64919796
    Ivan Duque Marquez 285405109
    Ivan Duque Marquez 2360343326
    Ivan Duque Marquez 476011253
    Ivan Duque Marquez 2503124194
    Ivan Duque Marquez 183338213
    Ivan Duque Marquez 941659381539721217
    Ivan Duque Marquez 69396376
    Ivan Duque Marquez 154836286
    Ivan Duque Marquez 174243123
    Ivan Duque Marquez 117705468
    Ivan Duque Marquez 301518493
    Ivan Duque Marquez 860556241
    Ivan Duque Marquez 74293265
    Ivan Duque Marquez 763162389198016512
    Ivan Duque Marquez 314889375
    Ivan Duque Marquez 82702071
    Ivan Duque Marquez 213769894
    Ivan Duque Marquez 2196442651
    Ivan Duque Marquez 252134272
    Ivan Duque Marquez 2513299995
    Ivan Duque Marquez 44983089
    Ivan Duque Marquez 203932135
    Ivan Duque Marquez 93890582
    Ivan Duque Marquez 3874254148
    Ivan Duque Marquez 477967325
    Ivan Duque Marquez 51134217
    Ivan Duque Marquez 379072195
    Ivan Duque Marquez 1069678676
    Ivan Duque Marquez 37193785
    Ivan Duque Marquez 217462992
    Ivan Duque Marquez 27805363
    Ivan Duque Marquez 2873771193
    Ivan Duque Marquez 67394262
    Ivan Duque Marquez 805623632
    Ivan Duque Marquez 352673744
    Ivan Duque Marquez 1621271
    Ivan Duque Marquez 128009878
    Ivan Duque Marquez 549745099
    Ivan Duque Marquez 361579318
    Ivan Duque Marquez 50701214
    Ivan Duque Marquez 348784800
    Ivan Duque Marquez 25323002
    Ivan Duque Marquez 40988451
    Ivan Duque Marquez 1118254976
    Ivan Duque Marquez 867140092686741504
    Ivan Duque Marquez 1871760524
    Ivan Duque Marquez 902952266717687813
    Ivan Duque Marquez 2451162825
    Ivan Duque Marquez 60096817
    Ivan Duque Marquez 249237240
    Ivan Duque Marquez 241784645
    Ivan Duque Marquez 3317785840
    Ivan Duque Marquez 239424776
    Ivan Duque Marquez 567152038
    Ivan Duque Marquez 2418146478
    Ivan Duque Marquez 256757292
    Ivan Duque Marquez 861000587298689024
    Ivan Duque Marquez 891644091406143489
    Ivan Duque Marquez 256268717
    Ivan Duque Marquez 279781163
    Ivan Duque Marquez 381953766
    Ivan Duque Marquez 472438060
    Ivan Duque Marquez 153067850
    Ivan Duque Marquez 152508785
    Ivan Duque Marquez 921512708
    Ivan Duque Marquez 596118600
    Ivan Duque Marquez 770335442
    Ivan Duque Marquez 897996368354189312
    Ivan Duque Marquez 141989197
    Ivan Duque Marquez 586572148
    Ivan Duque Marquez 752707660450041860
    Ivan Duque Marquez 1092271610
    Ivan Duque Marquez 856993824526266370
    Ivan Duque Marquez 887137566201434112
    Ivan Duque Marquez 3590007322
    Ivan Duque Marquez 255115415
    Ivan Duque Marquez 897835800011866112
    Ivan Duque Marquez 861707776816447488
    Ivan Duque Marquez 716834597200388096
    Ivan Duque Marquez 2350945969
    Ivan Duque Marquez 1499158801
    Ivan Duque Marquez 70297714
    Ivan Duque Marquez 2770801263
    Ivan Duque Marquez 892742874726621184
    Ivan Duque Marquez 866634066
    Ivan Duque Marquez 73738454
    Ivan Duque Marquez 1727357756
    Ivan Duque Marquez 621563145
    Ivan Duque Marquez 858741007
    Ivan Duque Marquez 893541643995025410
    Ivan Duque Marquez 273145333
    Ivan Duque Marquez 122494350
    Ivan Duque Marquez 188446972
    Ivan Duque Marquez 827669533359869952
    Ivan Duque Marquez 149606103
    Ivan Duque Marquez 4842215487
    Ivan Duque Marquez 2231377699
    Ivan Duque Marquez 161831597
    Ivan Duque Marquez 388396664
    Ivan Duque Marquez 764071236322426880
    Ivan Duque Marquez 143322830
    Ivan Duque Marquez 149910495
    Ivan Duque Marquez 331431220
    Ivan Duque Marquez 1593718208
    Ivan Duque Marquez 3081519007
    Ivan Duque Marquez 734028312608178177
    Ivan Duque Marquez 322902753
    Ivan Duque Marquez 242884845
    Ivan Duque Marquez 165911667
    Ivan Duque Marquez 293283464
    Ivan Duque Marquez 77083164
    Ivan Duque Marquez 64237373
    Ivan Duque Marquez 772602542
    Ivan Duque Marquez 282654181
    Ivan Duque Marquez 792407865025855488
    Ivan Duque Marquez 719001764926734336
    Ivan Duque Marquez 795295647125688321
    Ivan Duque Marquez 1307981143
    Ivan Duque Marquez 1042156536
    Ivan Duque Marquez 176771313
    Ivan Duque Marquez 2524199487
    Ivan Duque Marquez 634897321
    Ivan Duque Marquez 157712619
    Ivan Duque Marquez 3907437817
    Ivan Duque Marquez 246092093
    Ivan Duque Marquez 176628574
    Ivan Duque Marquez 67333512
    Ivan Duque Marquez 268560939
    Ivan Duque Marquez 1016479009
    Ivan Duque Marquez 85009312
    Ivan Duque Marquez 225386057
    Ivan Duque Marquez 144586563
    Ivan Duque Marquez 170724670
    Ivan Duque Marquez 314825981
    Ivan Duque Marquez 70306349
    Ivan Duque Marquez 354464020
    Ivan Duque Marquez 129007805
    Ivan Duque Marquez 114469124
    Ivan Duque Marquez 628727167
    Ivan Duque Marquez 1279112347
    Ivan Duque Marquez 231299309
    Ivan Duque Marquez 315424808
    Ivan Duque Marquez 600040496
    Ivan Duque Marquez 37287124
    Ivan Duque Marquez 834609484781723648
    Ivan Duque Marquez 1971714332
    Ivan Duque Marquez 1650730063
    Ivan Duque Marquez 1425639174
    Ivan Duque Marquez 17230854
    Ivan Duque Marquez 179712722
    Ivan Duque Marquez 823348278830002177
    Ivan Duque Marquez 905250199
    Ivan Duque Marquez 15246621
    Ivan Duque Marquez 366907915
    Ivan Duque Marquez 714481832
    Ivan Duque Marquez 3300493816
    Ivan Duque Marquez 3401638840
    Ivan Duque Marquez 1722201582
    Ivan Duque Marquez 1976143068
    Ivan Duque Marquez 3047175233
    Ivan Duque Marquez 75891845
    Ivan Duque Marquez 15012693
    Ivan Duque Marquez 54973156
    Ivan Duque Marquez 53778621
    Ivan Duque Marquez 102482331
    Ivan Duque Marquez 47491330
    Ivan Duque Marquez 42434332
    Ivan Duque Marquez 62917505
    Ivan Duque Marquez 16193496
    Ivan Duque Marquez 459748503
    Ivan Duque Marquez 23373369
    Ivan Duque Marquez 839479812456660992
    Ivan Duque Marquez 288465837
    Ivan Duque Marquez 121060114
    Ivan Duque Marquez 842718896474017794
    Ivan Duque Marquez 2713176725
    Ivan Duque Marquez 292712362
    Ivan Duque Marquez 718531595611807744
    Ivan Duque Marquez 74964230
    Ivan Duque Marquez 413198020
    Ivan Duque Marquez 289076280
    Ivan Duque Marquez 817777156994506752
    Ivan Duque Marquez 22123078
    Ivan Duque Marquez 5563262
    Ivan Duque Marquez 14260960
    Ivan Duque Marquez 46812983
    Ivan Duque Marquez 712005925884858368
    Ivan Duque Marquez 51077845
    Ivan Duque Marquez 822912942110871553
    Ivan Duque Marquez 515900234
    Ivan Duque Marquez 14119371
    Ivan Duque Marquez 469320757
    Ivan Duque Marquez 107124260
    Ivan Duque Marquez 172067666
    Ivan Duque Marquez 1635629952
    Ivan Duque Marquez 136773524
    Ivan Duque Marquez 772585150622343169
    Ivan Duque Marquez 766619655825920000
    Ivan Duque Marquez 71094049
    Ivan Duque Marquez 1113237756
    Ivan Duque Marquez 195034077
    Ivan Duque Marquez 150364123
    Ivan Duque Marquez 265752992
    Ivan Duque Marquez 93991568
    Ivan Duque Marquez 59179735
    Ivan Duque Marquez 159950603
    Ivan Duque Marquez 415924507
    Ivan Duque Marquez 2219053756
    Ivan Duque Marquez 473435525
    Ivan Duque Marquez 800889069769261056
    Ivan Duque Marquez 134855279
    Ivan Duque Marquez 129683990
    Ivan Duque Marquez 132599039
    Ivan Duque Marquez 2858784635
    Ivan Duque Marquez 298067179
    Ivan Duque Marquez 872139812
    Ivan Duque Marquez 923639036
    Ivan Duque Marquez 2874285407
    Ivan Duque Marquez 15973392
    Ivan Duque Marquez 66711542
    Ivan Duque Marquez 59637309
    Ivan Duque Marquez 41396492
    Ivan Duque Marquez 246622925
    Ivan Duque Marquez 1167296532
    Ivan Duque Marquez 215400240
    Ivan Duque Marquez 256161747
    Ivan Duque Marquez 744351896354316288
    Ivan Duque Marquez 773538196609175552
    Ivan Duque Marquez 708048865216299009
    Ivan Duque Marquez 2174690272
    Ivan Duque Marquez 302079383
    Ivan Duque Marquez 38227618
    Ivan Duque Marquez 51089510
    Ivan Duque Marquez 72970859
    Ivan Duque Marquez 777090858
    Ivan Duque Marquez 742404079415111681
    Ivan Duque Marquez 581937039
    Ivan Duque Marquez 1199051838
    Ivan Duque Marquez 304129707
    Ivan Duque Marquez 148396735
    Ivan Duque Marquez 2864524600
    Ivan Duque Marquez 321599013
    Ivan Duque Marquez 3420649965
    Ivan Duque Marquez 719288521492721664
    Ivan Duque Marquez 4729135481
    Ivan Duque Marquez 375854542
    Ivan Duque Marquez 62241389
    Ivan Duque Marquez 1730191662
    Ivan Duque Marquez 3130395220
    Ivan Duque Marquez 1677007038
    Ivan Duque Marquez 194660231
    Ivan Duque Marquez 2953640297
    Ivan Duque Marquez 16043472
    Ivan Duque Marquez 2461962151
    Ivan Duque Marquez 3242319215
    Ivan Duque Marquez 242087536
    Ivan Duque Marquez 46881592
    Ivan Duque Marquez 1710418214
    Ivan Duque Marquez 118232610
    Ivan Duque Marquez 65980123
    Ivan Duque Marquez 142735771
    Ivan Duque Marquez 192538987
    Ivan Duque Marquez 1199008584
    Ivan Duque Marquez 63796828
    Ivan Duque Marquez 2511967149
    Ivan Duque Marquez 284077206
    Ivan Duque Marquez 289496469
    Ivan Duque Marquez 562021313
    Ivan Duque Marquez 108765428
    Ivan Duque Marquez 776080627
    Ivan Duque Marquez 152056202
    Ivan Duque Marquez 2354969722
    Ivan Duque Marquez 716297985961828352
    Ivan Duque Marquez 230824627
    Ivan Duque Marquez 154282462
    Ivan Duque Marquez 628816878
    Ivan Duque Marquez 719735506834178048
    Ivan Duque Marquez 2304100195
    Ivan Duque Marquez 730775354177163264
    Ivan Duque Marquez 3085618447
    Ivan Duque Marquez 473323866
    Ivan Duque Marquez 1564841377
    Ivan Duque Marquez 3366639843
    Ivan Duque Marquez 531745717
    Ivan Duque Marquez 1419004664
    Ivan Duque Marquez 1337903352
    Ivan Duque Marquez 3240586599
    Ivan Duque Marquez 3115162667
    Ivan Duque Marquez 707785027258609664
    Ivan Duque Marquez 189189288
    Ivan Duque Marquez 703226678659706881
    Ivan Duque Marquez 240647505
    Ivan Duque Marquez 295934325
    Ivan Duque Marquez 472957301
    Ivan Duque Marquez 231340386
    Ivan Duque Marquez 1965156224
    Ivan Duque Marquez 228498424
    Ivan Duque Marquez 2709686844
    Ivan Duque Marquez 181191692
    Ivan Duque Marquez 80417990
    Ivan Duque Marquez 56583257
    Ivan Duque Marquez 55598030
    Ivan Duque Marquez 185662357
    Ivan Duque Marquez 48115306
    Ivan Duque Marquez 1623349022
    Ivan Duque Marquez 108090029
    Ivan Duque Marquez 488524617
    Ivan Duque Marquez 86622012
    Ivan Duque Marquez 1619265078
    Ivan Duque Marquez 2951995276
    Ivan Duque Marquez 510423261
    Ivan Duque Marquez 1373440410
    Ivan Duque Marquez 249207360
    Ivan Duque Marquez 1267379785
    Ivan Duque Marquez 586645011
    Ivan Duque Marquez 98734035
    Ivan Duque Marquez 1235624576
    Ivan Duque Marquez 353729690
    Ivan Duque Marquez 224865888
    Ivan Duque Marquez 181015995
    Ivan Duque Marquez 196731630
    Ivan Duque Marquez 83861270
    Ivan Duque Marquez 951643866
    Ivan Duque Marquez 67462607
    Ivan Duque Marquez 1969105825
    Ivan Duque Marquez 93681558
    Ivan Duque Marquez 178064645
    Ivan Duque Marquez 347608751
    Ivan Duque Marquez 930299516
    Ivan Duque Marquez 2249369569
    Ivan Duque Marquez 1409044500
    Ivan Duque Marquez 2157851091
    Ivan Duque Marquez 13285502
    Ivan Duque Marquez 288060958
    Ivan Duque Marquez 48151996
    Ivan Duque Marquez 65728343
    Ivan Duque Marquez 476298796
    Ivan Duque Marquez 300010882
    Ivan Duque Marquez 284708747
    Ivan Duque Marquez 3424535308
    Ivan Duque Marquez 716786982962216962
    Ivan Duque Marquez 37723353
    Ivan Duque Marquez 2385322789
    Ivan Duque Marquez 119844526
    Ivan Duque Marquez 50360327
    Ivan Duque Marquez 625759230
    Ivan Duque Marquez 822215679726100480
    Ivan Duque Marquez 1536791610
    Ivan Duque Marquez 136300373
    Ivan Duque Marquez 97017966
    Ivan Duque Marquez 578726904
    Ivan Duque Marquez 176331517
    Ivan Duque Marquez 208308070
    Ivan Duque Marquez 64419705
    Ivan Duque Marquez 104253734
    Ivan Duque Marquez 57107167
    Ivan Duque Marquez 68882728
    Ivan Duque Marquez 2810617835
    Ivan Duque Marquez 1444915238
    Ivan Duque Marquez 184642563
    Ivan Duque Marquez 3158503239
    Ivan Duque Marquez 234053160
    Ivan Duque Marquez 140177593
    Ivan Duque Marquez 703394216
    Ivan Duque Marquez 501927211
    Ivan Duque Marquez 2863586628
    Ivan Duque Marquez 3815451208
    Ivan Duque Marquez 290541347
    Ivan Duque Marquez 348260221
    Ivan Duque Marquez 486226178
    Ivan Duque Marquez 1481113290
    Ivan Duque Marquez 1243870310
    Ivan Duque Marquez 1444220634
    Ivan Duque Marquez 79868273
    Ivan Duque Marquez 1658044423
    Ivan Duque Marquez 60082021
    Ivan Duque Marquez 67167025
    Ivan Duque Marquez 202644027
    Ivan Duque Marquez 208410562
    Ivan Duque Marquez 201845752
    Ivan Duque Marquez 3492009855
    Ivan Duque Marquez 167856260
    Ivan Duque Marquez 280701704
    Ivan Duque Marquez 4893595829
    Ivan Duque Marquez 17839398
    Ivan Duque Marquez 546281726
    Ivan Duque Marquez 90527443
    Ivan Duque Marquez 142522750
    Ivan Duque Marquez 365214624
    Ivan Duque Marquez 2931221939
    Ivan Duque Marquez 104014976
    Ivan Duque Marquez 143945668
    Ivan Duque Marquez 157875833
    Ivan Duque Marquez 118563867
    Ivan Duque Marquez 612551899
    Ivan Duque Marquez 83188294
    Ivan Duque Marquez 14872237
    Ivan Duque Marquez 308257399
    Ivan Duque Marquez 626743228
    Ivan Duque Marquez 1102528734
    Ivan Duque Marquez 178378807
    Ivan Duque Marquez 67038807
    Ivan Duque Marquez 14786159
    Ivan Duque Marquez 259743264
    Ivan Duque Marquez 818609250
    Ivan Duque Marquez 529569429
    Ivan Duque Marquez 106599538
    Ivan Duque Marquez 126204564
    Ivan Duque Marquez 377450840
    Ivan Duque Marquez 24645902
    Ivan Duque Marquez 2467852782
    Ivan Duque Marquez 88222741
    Ivan Duque Marquez 195389025
    Ivan Duque Marquez 586861205
    Ivan Duque Marquez 2345964548
    Ivan Duque Marquez 221622311
    Ivan Duque Marquez 408166128
    Ivan Duque Marquez 239610226
    Ivan Duque Marquez 326461309
    Ivan Duque Marquez 285180126
    Ivan Duque Marquez 211655548
    Ivan Duque Marquez 83670663
    Ivan Duque Marquez 304617817
    Ivan Duque Marquez 143906233
    Ivan Duque Marquez 73272710
    Ivan Duque Marquez 65460693
    Ivan Duque Marquez 57156283
    Ivan Duque Marquez 3130237630
    Ivan Duque Marquez 85644743
    Ivan Duque Marquez 3418245580
    Ivan Duque Marquez 144191840
    Ivan Duque Marquez 283311686
    Ivan Duque Marquez 2239586222
    Ivan Duque Marquez 195395453
    Ivan Duque Marquez 372868087
    Ivan Duque Marquez 304474863
    Ivan Duque Marquez 95665360
    Ivan Duque Marquez 304502574
    Ivan Duque Marquez 180861689
    Ivan Duque Marquez 155456120
    Ivan Duque Marquez 143816850
    Ivan Duque Marquez 192976204
    Ivan Duque Marquez 150079309
    Ivan Duque Marquez 271501187
    Ivan Duque Marquez 61018481
    Ivan Duque Marquez 71543713
    Ivan Duque Marquez 1129246914
    Ivan Duque Marquez 580993736
    Ivan Duque Marquez 141669797
    Ivan Duque Marquez 3248048272
    Ivan Duque Marquez 1711564176
    Ivan Duque Marquez 1653546440
    Ivan Duque Marquez 321451027
    Ivan Duque Marquez 320985624
    Ivan Duque Marquez 3696454696
    Ivan Duque Marquez 276791626
    Ivan Duque Marquez 202860440
    Ivan Duque Marquez 88223869
    Ivan Duque Marquez 200560984
    Ivan Duque Marquez 575830125
    Ivan Duque Marquez 864838680
    Ivan Duque Marquez 176924107
    Ivan Duque Marquez 1078568264
    Ivan Duque Marquez 150444438
    Ivan Duque Marquez 956966994
    Ivan Duque Marquez 1027270314
    Ivan Duque Marquez 169622130
    Ivan Duque Marquez 2169662044
    Ivan Duque Marquez 275669169
    Ivan Duque Marquez 343813435
    Ivan Duque Marquez 180217743
    Ivan Duque Marquez 3050537774
    Ivan Duque Marquez 271483058
    Ivan Duque Marquez 293012562
    Ivan Duque Marquez 710943440
    Ivan Duque Marquez 593765767
    Ivan Duque Marquez 2176800865
    Ivan Duque Marquez 310669514
    Ivan Duque Marquez 43043907
    Ivan Duque Marquez 270326631
    Ivan Duque Marquez 626073534
    Ivan Duque Marquez 146527065
    Ivan Duque Marquez 154220920
    Ivan Duque Marquez 30861738
    Ivan Duque Marquez 26946244
    Ivan Duque Marquez 384604339
    Ivan Duque Marquez 2377008313
    Ivan Duque Marquez 2382725952
    Ivan Duque Marquez 153044706
    Ivan Duque Marquez 470333556
    Ivan Duque Marquez 3030848893
    Ivan Duque Marquez 495218221
    Ivan Duque Marquez 166252036
    Ivan Duque Marquez 380695419
    Ivan Duque Marquez 274639464
    Ivan Duque Marquez 354120123
    Ivan Duque Marquez 149349219
    Ivan Duque Marquez 339398560
    Ivan Duque Marquez 213539643
    Ivan Duque Marquez 56440383
    Ivan Duque Marquez 95494483
    Ivan Duque Marquez 46739762
    Ivan Duque Marquez 154000683
    Ivan Duque Marquez 1148951600
    Ivan Duque Marquez 431929131
    Ivan Duque Marquez 2391834968
    Ivan Duque Marquez 560336588
    Ivan Duque Marquez 302794483
    Ivan Duque Marquez 53480462
    Ivan Duque Marquez 723346694
    Ivan Duque Marquez 3290218899
    Ivan Duque Marquez 3193116503
    Ivan Duque Marquez 230240898
    Ivan Duque Marquez 851891599
    Ivan Duque Marquez 585326862
    Ivan Duque Marquez 287778369
    Ivan Duque Marquez 2870759343
    Ivan Duque Marquez 458659559
    Ivan Duque Marquez 174319969
    Ivan Duque Marquez 415079571
    Ivan Duque Marquez 18251382
    Ivan Duque Marquez 109996414
    Ivan Duque Marquez 89051828
    Ivan Duque Marquez 3198622317
    Ivan Duque Marquez 89109653
    Ivan Duque Marquez 294929596
    Ivan Duque Marquez 620690358
    Ivan Duque Marquez 213517579
    Ivan Duque Marquez 305818276
    Ivan Duque Marquez 144687029
    Ivan Duque Marquez 32128679
    Ivan Duque Marquez 140888637
    Ivan Duque Marquez 87775422
    Ivan Duque Marquez 17990493
    Ivan Duque Marquez 169021842
    Ivan Duque Marquez 16334857
    Ivan Duque Marquez 11127482
    Ivan Duque Marquez 473863406
    Ivan Duque Marquez 305097344
    Ivan Duque Marquez 15450996
    Ivan Duque Marquez 60161414
    Ivan Duque Marquez 30864583
    Ivan Duque Marquez 305611913
    Ivan Duque Marquez 592878988
    Ivan Duque Marquez 320574406
    Ivan Duque Marquez 583938358
    Ivan Duque Marquez 68755646
    Ivan Duque Marquez 115097756
    Ivan Duque Marquez 281859997
    Ivan Duque Marquez 60693203
    Ivan Duque Marquez 74159604
    Ivan Duque Marquez 1223389590
    Ivan Duque Marquez 215142606
    Ivan Duque Marquez 59486068
    Ivan Duque Marquez 18938646
    Ivan Duque Marquez 863527548
    Ivan Duque Marquez 325953031
    Ivan Duque Marquez 22386555
    Ivan Duque Marquez 203767718
    Ivan Duque Marquez 1918235983
    Ivan Duque Marquez 465479364
    Ivan Duque Marquez 346510738
    Ivan Duque Marquez 24900072
    Ivan Duque Marquez 152010594
    Ivan Duque Marquez 433050682
    Ivan Duque Marquez 2382410672
    Ivan Duque Marquez 78188601
    Ivan Duque Marquez 514520753
    Ivan Duque Marquez 291492707
    Ivan Duque Marquez 61109238
    Ivan Duque Marquez 104514448
    Ivan Duque Marquez 255496828
    Ivan Duque Marquez 445534390
    Ivan Duque Marquez 132968680
    Ivan Duque Marquez 428447897
    Ivan Duque Marquez 54906637
    Ivan Duque Marquez 320729267
    Ivan Duque Marquez 365857781
    Ivan Duque Marquez 323938537
    Ivan Duque Marquez 92785405
    Ivan Duque Marquez 239503510
    Ivan Duque Marquez 364892871
    Ivan Duque Marquez 214102358
    Ivan Duque Marquez 71532241
    Ivan Duque Marquez 309229905
    Ivan Duque Marquez 188828788
    Ivan Duque Marquez 560683455
    Ivan Duque Marquez 1049989213
    Ivan Duque Marquez 1931332333
    Ivan Duque Marquez 392320818
    Ivan Duque Marquez 229966028
    Ivan Duque Marquez 2307051969
    Ivan Duque Marquez 163341528
    Ivan Duque Marquez 1208577252
    Ivan Duque Marquez 129546501
    Ivan Duque Marquez 1054949095
    Ivan Duque Marquez 2684210810
    Ivan Duque Marquez 141071036
    Ivan Duque Marquez 165130896
    Ivan Duque Marquez 33243404
    Ivan Duque Marquez 2546780857
    Ivan Duque Marquez 17047743
    Ivan Duque Marquez 71560212
    Ivan Duque Marquez 89485410
    Ivan Duque Marquez 20562637
    Ivan Duque Marquez 176395929
    Ivan Duque Marquez 560799132
    Ivan Duque Marquez 2303168342
    Ivan Duque Marquez 50675591
    Ivan Duque Marquez 18949452
    Ivan Duque Marquez 1725974826
    Ivan Duque Marquez 20376276
    Ivan Duque Marquez 16458727
    Ivan Duque Marquez 18080969
    Ivan Duque Marquez 15492359
    Ivan Duque Marquez 79150794
    Ivan Duque Marquez 96779730
    Ivan Duque Marquez 82697443
    Ivan Duque Marquez 80936145
    Ivan Duque Marquez 7157292
    Ivan Duque Marquez 245192492
    Ivan Duque Marquez 77047295
    Ivan Duque Marquez 150353783
    Ivan Duque Marquez 82267221
    Ivan Duque Marquez 154588112
    Ivan Duque Marquez 389611283
    Ivan Duque Marquez 111188115
    Ivan Duque Marquez 154294030
    Ivan Duque Marquez 154670681
    Ivan Duque Marquez 176931171
    Ivan Duque Marquez 75400667
    Ivan Duque Marquez 165748292
    Ivan Duque Marquez 99760047
    Ivan Duque Marquez 187982680
    Ivan Duque Marquez 142454580
    Ivan Duque Marquez 15404821
    Ivan Duque Marquez 143924206
    Ivan Duque Marquez 219990061
    Ivan Duque Marquez 242425204
    Ivan Duque Marquez 300541155
    Ivan Duque Marquez 296304120
    Ivan Duque Marquez 346586565
    Ivan Duque Marquez 615721665
    Ivan Duque Marquez 478892632
    Ivan Duque Marquez 151088536
    Ivan Duque Marquez 191465222
    Ivan Duque Marquez 91181758
    Ivan Duque Marquez 259905646
    Ivan Duque Marquez 126672796
    Ivan Duque Marquez 131596061
    Ivan Duque Marquez 262398126
    Ivan Duque Marquez 602853869
    Ivan Duque Marquez 306248882
    Ivan Duque Marquez 381725074
    Ivan Duque Marquez 131273553
    Ivan Duque Marquez 345214995
    Ivan Duque Marquez 518979494
    Ivan Duque Marquez 179584524
    Ivan Duque Marquez 461262093
    Ivan Duque Marquez 2432027873
    Ivan Duque Marquez 378923633
    Ivan Duque Marquez 45048977
    Ivan Duque Marquez 222180430
    Ivan Duque Marquez 509735057
    Ivan Duque Marquez 246826243
    Ivan Duque Marquez 2410543611
    Ivan Duque Marquez 2508877385
    Ivan Duque Marquez 26513260
    Ivan Duque Marquez 161647688
    Ivan Duque Marquez 167535742
    Ivan Duque Marquez 21961602
    Ivan Duque Marquez 2472157361
    Ivan Duque Marquez 46536874
    Ivan Duque Marquez 295729528
    Ivan Duque Marquez 1713006540
    Ivan Duque Marquez 1887095647
    Ivan Duque Marquez 197566379
    Ivan Duque Marquez 143196331
    Ivan Duque Marquez 119241934
    Ivan Duque Marquez 1431395113
    Ivan Duque Marquez 137136273
    Ivan Duque Marquez 253739701
    Ivan Duque Marquez 237524975
    Ivan Duque Marquez 1252921626
    Ivan Duque Marquez 1242777318
    Ivan Duque Marquez 2540089568
    Ivan Duque Marquez 157700651
    Ivan Duque Marquez 177038215
    Ivan Duque Marquez 348121596
    Ivan Duque Marquez 30512426
    Ivan Duque Marquez 113138316
    Ivan Duque Marquez 791986934
    Ivan Duque Marquez 72926357
    Ivan Duque Marquez 164033062
    Ivan Duque Marquez 138652661
    Ivan Duque Marquez 104980428
    Ivan Duque Marquez 2411886678
    Ivan Duque Marquez 75648469
    Ivan Duque Marquez 1339650306
    Ivan Duque Marquez 361960956
    Ivan Duque Marquez 51297598
    Ivan Duque Marquez 567865254
    Ivan Duque Marquez 2385466728
    Ivan Duque Marquez 112319301
    Ivan Duque Marquez 2741017434
    Ivan Duque Marquez 328801251
    Ivan Duque Marquez 324441507
    Ivan Duque Marquez 1231456292
    Ivan Duque Marquez 1057031762
    Ivan Duque Marquez 339205795
    Ivan Duque Marquez 279224761
    Ivan Duque Marquez 32285502
    Ivan Duque Marquez 277667498
    Ivan Duque Marquez 1239951966
    Ivan Duque Marquez 551970102
    Ivan Duque Marquez 769353138
    Ivan Duque Marquez 463499774
    Ivan Duque Marquez 1349383470
    Ivan Duque Marquez 1415607506
    Ivan Duque Marquez 48724687
    Ivan Duque Marquez 1370533680
    Ivan Duque Marquez 51917943
    Ivan Duque Marquez 263506326
    Ivan Duque Marquez 25347345
    Ivan Duque Marquez 95209582
    Ivan Duque Marquez 587719150
    Ivan Duque Marquez 370270477
    Ivan Duque Marquez 52098923
    Ivan Duque Marquez 190613145
    Ivan Duque Marquez 127416126
    Ivan Duque Marquez 53381930
    Ivan Duque Marquez 147740901
    Ivan Duque Marquez 631953392
    Ivan Duque Marquez 152368149
    Ivan Duque Marquez 141077263
    Ivan Duque Marquez 47085613
    Ivan Duque Marquez 1860642996
    Ivan Duque Marquez 626057802
    Ivan Duque Marquez 10690342
    Ivan Duque Marquez 386806997
    Ivan Duque Marquez 130168104
    Ivan Duque Marquez 294025129
    Ivan Duque Marquez 311782246
    Ivan Duque Marquez 536892387
    Ivan Duque Marquez 136486563
    Ivan Duque Marquez 128454098
    

    Rate limit reached. Sleeping for: 707
    

    Ivan Duque Marquez 269919164
    Ivan Duque Marquez 188787847
    Ivan Duque Marquez 148078549
    Ivan Duque Marquez 259890586
    Ivan Duque Marquez 35279819
    Ivan Duque Marquez 215850743
    Ivan Duque Marquez 339213774
    Ivan Duque Marquez 96607342
    Ivan Duque Marquez 1563206833
    Ivan Duque Marquez 19646347
    Ivan Duque Marquez 594693447
    Ivan Duque Marquez 1004732484
    Ivan Duque Marquez 291747037
    Ivan Duque Marquez 2516761986
    Ivan Duque Marquez 334752501
    Ivan Duque Marquez 1707237798
    Ivan Duque Marquez 32915530
    Ivan Duque Marquez 1276440104
    Ivan Duque Marquez 286864730
    Ivan Duque Marquez 177992268
    Ivan Duque Marquez 16141571
    Ivan Duque Marquez 574450141
    Ivan Duque Marquez 76941349
    Ivan Duque Marquez 1947416730
    Ivan Duque Marquez 45733091
    Ivan Duque Marquez 2147952506
    Ivan Duque Marquez 1172590632
    Ivan Duque Marquez 220046344
    Ivan Duque Marquez 556570281
    Ivan Duque Marquez 207671036
    Ivan Duque Marquez 37749296
    Ivan Duque Marquez 437854084
    Ivan Duque Marquez 50772662
    Ivan Duque Marquez 59629962
    Ivan Duque Marquez 379240947
    Ivan Duque Marquez 178426530
    Ivan Duque Marquez 2420923164
    Ivan Duque Marquez 731070530
    Ivan Duque Marquez 2846606686
    Ivan Duque Marquez 70460649
    Ivan Duque Marquez 174691842
    Ivan Duque Marquez 2784594951
    Ivan Duque Marquez 15283447
    Ivan Duque Marquez 184109564
    Ivan Duque Marquez 2902445957
    Ivan Duque Marquez 424967935
    Ivan Duque Marquez 219416421
    Ivan Duque Marquez 58528250
    Ivan Duque Marquez 520844736
    Ivan Duque Marquez 726684187
    Ivan Duque Marquez 12398822
    Ivan Duque Marquez 935203441
    Ivan Duque Marquez 138914238
    Ivan Duque Marquez 515821672
    Ivan Duque Marquez 35883193
    Ivan Duque Marquez 74060984
    Ivan Duque Marquez 1909474604
    Ivan Duque Marquez 168700229
    Ivan Duque Marquez 28771597
    Ivan Duque Marquez 274523797
    Ivan Duque Marquez 776899466
    Ivan Duque Marquez 142017929
    Ivan Duque Marquez 266134103
    Ivan Duque Marquez 118886100
    Ivan Duque Marquez 1704824593
    Ivan Duque Marquez 253167239
    Ivan Duque Marquez 473338133
    Ivan Duque Marquez 199492223
    Ivan Duque Marquez 134958111
    Ivan Duque Marquez 1961510274
    Ivan Duque Marquez 119054672
    Ivan Duque Marquez 2412495021
    Ivan Duque Marquez 180113520
    Ivan Duque Marquez 487709592
    Ivan Duque Marquez 142820741
    Ivan Duque Marquez 63483497
    Ivan Duque Marquez 264056743
    Ivan Duque Marquez 742769480
    Ivan Duque Marquez 173467569
    Ivan Duque Marquez 398637444
    Ivan Duque Marquez 77243413
    Ivan Duque Marquez 1430896860
    Ivan Duque Marquez 1362953436
    Ivan Duque Marquez 498880560
    Ivan Duque Marquez 201322764
    Ivan Duque Marquez 2385794358
    Ivan Duque Marquez 144694085
    Ivan Duque Marquez 256541943
    Ivan Duque Marquez 75946922
    Ivan Duque Marquez 125705907
    Ivan Duque Marquez 2262998136
    Ivan Duque Marquez 1110254012
    Ivan Duque Marquez 36693568
    Ivan Duque Marquez 248755345
    Ivan Duque Marquez 18790963
    Ivan Duque Marquez 2427117497
    Ivan Duque Marquez 2866370699
    Ivan Duque Marquez 127329882
    Ivan Duque Marquez 64430448
    Ivan Duque Marquez 2423412582
    Ivan Duque Marquez 2231696656
    Ivan Duque Marquez 2484605090
    Ivan Duque Marquez 128334306
    Ivan Duque Marquez 108185785
    Ivan Duque Marquez 64527260
    Ivan Duque Marquez 141987296
    Ivan Duque Marquez 163249098
    Ivan Duque Marquez 117185027
    Ivan Duque Marquez 388842952
    Ivan Duque Marquez 809310276
    Ivan Duque Marquez 775475923
    Ivan Duque Marquez 50442705
    Ivan Duque Marquez 168865939
    Ivan Duque Marquez 282843681
    Ivan Duque Marquez 1587519182
    Ivan Duque Marquez 711155379
    Ivan Duque Marquez 143469633
    Ivan Duque Marquez 49320282
    Ivan Duque Marquez 58531272
    Ivan Duque Marquez 66740100
    Ivan Duque Marquez 20514852
    Ivan Duque Marquez 64599996
    Ivan Duque Marquez 24196553
    Ivan Duque Marquez 329463917
    Ivan Duque Marquez 321927518
    Ivan Duque Marquez 218252776
    Ivan Duque Marquez 2411541594
    Ivan Duque Marquez 219750815
    Ivan Duque Marquez 93416425
    Ivan Duque Marquez 2746986980
    Ivan Duque Marquez 606584678
    Ivan Duque Marquez 1892186648
    Ivan Duque Marquez 2599941631
    Ivan Duque Marquez 213051585
    Ivan Duque Marquez 163635292
    Ivan Duque Marquez 153154765
    Ivan Duque Marquez 2177040541
    Ivan Duque Marquez 14870177
    Ivan Duque Marquez 131144285
    Ivan Duque Marquez 80353633
    Ivan Duque Marquez 238919402
    Ivan Duque Marquez 281262004
    Ivan Duque Marquez 45587675
    Ivan Duque Marquez 1169119442
    Ivan Duque Marquez 59258459
    Ivan Duque Marquez 1903940562
    Ivan Duque Marquez 2687968392
    Ivan Duque Marquez 156703125
    Ivan Duque Marquez 809089520
    Ivan Duque Marquez 53460860
    Ivan Duque Marquez 9633802
    Ivan Duque Marquez 880585609
    Ivan Duque Marquez 127912014
    Ivan Duque Marquez 376326913
    Ivan Duque Marquez 2690788812
    Ivan Duque Marquez 26361537
    Ivan Duque Marquez 424386209
    Ivan Duque Marquez 435215847
    Ivan Duque Marquez 150248933
    Ivan Duque Marquez 1915063518
    Ivan Duque Marquez 45146844
    Ivan Duque Marquez 22488241
    Ivan Duque Marquez 178718239
    Ivan Duque Marquez 126832572
    Ivan Duque Marquez 21938850
    Ivan Duque Marquez 38670671
    Ivan Duque Marquez 40918718
    Ivan Duque Marquez 53187962
    Ivan Duque Marquez 130954763
    Ivan Duque Marquez 50409656
    Ivan Duque Marquez 320411043
    Ivan Duque Marquez 332980452
    Ivan Duque Marquez 173588099
    Ivan Duque Marquez 388937522
    Ivan Duque Marquez 103553441
    Ivan Duque Marquez 200159157
    Ivan Duque Marquez 1663367232
    Ivan Duque Marquez 1122599947
    Ivan Duque Marquez 185278894
    Ivan Duque Marquez 148925237
    Ivan Duque Marquez 152394247
    Ivan Duque Marquez 493595816
    Ivan Duque Marquez 382723182
    Ivan Duque Marquez 37341338
    Ivan Duque Marquez 377553700
    Ivan Duque Marquez 625803193
    Ivan Duque Marquez 1673455998
    Ivan Duque Marquez 319012946
    Ivan Duque Marquez 173224652
    Ivan Duque Marquez 104162716
    Ivan Duque Marquez 148350045
    Ivan Duque Marquez 66802357
    Ivan Duque Marquez 1419899384
    Ivan Duque Marquez 571894081
    Ivan Duque Marquez 2215811070
    Ivan Duque Marquez 355547837
    Ivan Duque Marquez 371797057
    Ivan Duque Marquez 874916178
    Ivan Duque Marquez 261814819
    Ivan Duque Marquez 1597352947
    Ivan Duque Marquez 268346350
    Ivan Duque Marquez 214508615
    Ivan Duque Marquez 269470862
    Ivan Duque Marquez 312771413
    Ivan Duque Marquez 1115683687
    Ivan Duque Marquez 153006822
    Ivan Duque Marquez 115259589
    Ivan Duque Marquez 1632991621
    Ivan Duque Marquez 283318070
    Ivan Duque Marquez 494640530
    Ivan Duque Marquez 2353021594
    Ivan Duque Marquez 3471921
    Ivan Duque Marquez 2587397594
    Ivan Duque Marquez 245573442
    Ivan Duque Marquez 47858163
    Ivan Duque Marquez 204023320
    Ivan Duque Marquez 162468551
    Ivan Duque Marquez 2554776608
    Ivan Duque Marquez 136426609
    Ivan Duque Marquez 270417803
    Ivan Duque Marquez 39863994
    Ivan Duque Marquez 309884223
    Ivan Duque Marquez 249022365
    Ivan Duque Marquez 122792985
    Ivan Duque Marquez 54203675
    Ivan Duque Marquez 52429642
    Ivan Duque Marquez 89619368
    Ivan Duque Marquez 205196160
    Ivan Duque Marquez 33574069
    Ivan Duque Marquez 172698760
    Ivan Duque Marquez 716830297
    Ivan Duque Marquez 1472603478
    Ivan Duque Marquez 15604291
    Ivan Duque Marquez 414250918
    Ivan Duque Marquez 462220933
    Ivan Duque Marquez 35389699
    Ivan Duque Marquez 26060210
    Ivan Duque Marquez 612791811
    Ivan Duque Marquez 994365818
    Ivan Duque Marquez 333437121
    Ivan Duque Marquez 276073974
    Ivan Duque Marquez 756391692
    Ivan Duque Marquez 115757603
    Ivan Duque Marquez 553073324
    Ivan Duque Marquez 60065982
    Ivan Duque Marquez 126362011
    Ivan Duque Marquez 703502070
    Ivan Duque Marquez 277206820
    Ivan Duque Marquez 2437920138
    Ivan Duque Marquez 139118143
    Ivan Duque Marquez 295685984
    Ivan Duque Marquez 620136960
    Ivan Duque Marquez 284178065
    Ivan Duque Marquez 148552267
    Ivan Duque Marquez 448152922
    Ivan Duque Marquez 592415328
    Ivan Duque Marquez 336706399
    Ivan Duque Marquez 724177039
    Ivan Duque Marquez 1246288244
    Ivan Duque Marquez 2442847218
    Ivan Duque Marquez 70786182
    Ivan Duque Marquez 120527624
    Ivan Duque Marquez 1540047080
    Ivan Duque Marquez 502343604
    Ivan Duque Marquez 1440132410
    Ivan Duque Marquez 2429619508
    Ivan Duque Marquez 1544111030
    Ivan Duque Marquez 104938249
    Ivan Duque Marquez 858887923
    Ivan Duque Marquez 582076307
    Ivan Duque Marquez 128376559
    Ivan Duque Marquez 325325210
    Ivan Duque Marquez 69432342
    Ivan Duque Marquez 29885219
    Ivan Duque Marquez 122587375
    Ivan Duque Marquez 139920277
    Ivan Duque Marquez 207601093
    Ivan Duque Marquez 161306075
    Ivan Duque Marquez 253183101
    Ivan Duque Marquez 1565999226
    Ivan Duque Marquez 387958397
    Ivan Duque Marquez 329888286
    Ivan Duque Marquez 146269675
    Ivan Duque Marquez 216915653
    Ivan Duque Marquez 346284586
    Ivan Duque Marquez 213292271
    Ivan Duque Marquez 149342934
    Ivan Duque Marquez 179252600
    Ivan Duque Marquez 792230988
    Ivan Duque Marquez 2160967057
    Ivan Duque Marquez 1908790878
    Ivan Duque Marquez 40791640
    Ivan Duque Marquez 774302174
    Ivan Duque Marquez 50155518
    Ivan Duque Marquez 60112193
    Ivan Duque Marquez 165850095
    Ivan Duque Marquez 827954622
    Ivan Duque Marquez 215480636
    Ivan Duque Marquez 71625898
    Ivan Duque Marquez 68816511
    Ivan Duque Marquez 186543552
    Ivan Duque Marquez 157526161
    Ivan Duque Marquez 289049261
    Ivan Duque Marquez 128685685
    Ivan Duque Marquez 174868032
    Ivan Duque Marquez 50812392
    Ivan Duque Marquez 544503695
    Ivan Duque Marquez 1849751766
    Ivan Duque Marquez 285945591
    Ivan Duque Marquez 2371187156
    Ivan Duque Marquez 83283407
    Ivan Duque Marquez 66709449
    Ivan Duque Marquez 513396244
    Ivan Duque Marquez 177838137
    Ivan Duque Marquez 292658326
    Ivan Duque Marquez 199832747
    Ivan Duque Marquez 187262522
    Ivan Duque Marquez 197023730
    Ivan Duque Marquez 98687169
    Ivan Duque Marquez 73925667
    Ivan Duque Marquez 242871430
    Ivan Duque Marquez 48537487
    Ivan Duque Marquez 285294793
    Ivan Duque Marquez 8314142
    Ivan Duque Marquez 118425472
    Ivan Duque Marquez 129330718
    Ivan Duque Marquez 219148114
    Ivan Duque Marquez 21860431
    Ivan Duque Marquez 1601822730
    Ivan Duque Marquez 522773806
    Ivan Duque Marquez 306848880
    Ivan Duque Marquez 87356295
    Ivan Duque Marquez 2356701395
    Ivan Duque Marquez 2246979255
    Ivan Duque Marquez 606657005
    Ivan Duque Marquez 493239443
    Ivan Duque Marquez 2336735322
    Ivan Duque Marquez 350862112
    Ivan Duque Marquez 429513933
    Ivan Duque Marquez 212288591
    Ivan Duque Marquez 635229486
    Ivan Duque Marquez 939413809
    Ivan Duque Marquez 327121987
    Ivan Duque Marquez 587648569
    Ivan Duque Marquez 271591884
    Ivan Duque Marquez 183091193
    Ivan Duque Marquez 63044413
    Ivan Duque Marquez 2182859274
    Ivan Duque Marquez 139021173
    Ivan Duque Marquez 361539175
    Ivan Duque Marquez 238787690
    Ivan Duque Marquez 226892994
    Ivan Duque Marquez 234840449
    Ivan Duque Marquez 1096622028
    Ivan Duque Marquez 302205893
    Ivan Duque Marquez 305059478
    Ivan Duque Marquez 88560168
    Ivan Duque Marquez 212742332
    Ivan Duque Marquez 134345226
    Ivan Duque Marquez 29985685
    Ivan Duque Marquez 199811461
    Ivan Duque Marquez 180052880
    Ivan Duque Marquez 159301772
    Ivan Duque Marquez 1663775444
    Ivan Duque Marquez 413211119
    Ivan Duque Marquez 303505740
    Ivan Duque Marquez 82378358
    Ivan Duque Marquez 582797989
    Ivan Duque Marquez 804406116
    Ivan Duque Marquez 281543018
    Ivan Duque Marquez 40617292
    Ivan Duque Marquez 65496599
    Ivan Duque Marquez 721373961
    Ivan Duque Marquez 140139017
    Ivan Duque Marquez 2263616504
    Ivan Duque Marquez 1307790096
    Ivan Duque Marquez 220598715
    Ivan Duque Marquez 74346722
    Ivan Duque Marquez 12542002
    Ivan Duque Marquez 126975727
    Ivan Duque Marquez 287176241
    Ivan Duque Marquez 896279587
    Ivan Duque Marquez 53485706
    Ivan Duque Marquez 737636424
    Ivan Duque Marquez 1123284564
    Ivan Duque Marquez 76395825
    Ivan Duque Marquez 68797435
    Ivan Duque Marquez 35612204
    Ivan Duque Marquez 2260207265
    Ivan Duque Marquez 56754332
    Ivan Duque Marquez 30250196
    Ivan Duque Marquez 235307099
    Ivan Duque Marquez 229954058
    Ivan Duque Marquez 139724188
    Ivan Duque Marquez 147334355
    Ivan Duque Marquez 774628742
    Ivan Duque Marquez 865408656
    Ivan Duque Marquez 52813180
    Ivan Duque Marquez 114798532
    Ivan Duque Marquez 278167964
    Ivan Duque Marquez 459307858
    Ivan Duque Marquez 116939135
    Ivan Duque Marquez 157381906
    Ivan Duque Marquez 288016741
    Ivan Duque Marquez 702171650
    Ivan Duque Marquez 142013899
    Ivan Duque Marquez 1353399656
    Ivan Duque Marquez 394227660
    Ivan Duque Marquez 465089702
    Ivan Duque Marquez 406706695
    Ivan Duque Marquez 34155845
    Ivan Duque Marquez 225856993
    Ivan Duque Marquez 67944314
    Ivan Duque Marquez 260234767
    Ivan Duque Marquez 155617063
    Ivan Duque Marquez 504914052
    Ivan Duque Marquez 289434674
    Ivan Duque Marquez 403503110
    Ivan Duque Marquez 223277224
    Ivan Duque Marquez 1912178808
    Ivan Duque Marquez 57401722
    Ivan Duque Marquez 2292841237
    Ivan Duque Marquez 521274222
    Ivan Duque Marquez 1003915128
    Ivan Duque Marquez 346303806
    Ivan Duque Marquez 140444678
    Ivan Duque Marquez 118256224
    Ivan Duque Marquez 214249964
    Ivan Duque Marquez 347492967
    Ivan Duque Marquez 284544447
    Ivan Duque Marquez 310928715
    Ivan Duque Marquez 230075040
    Ivan Duque Marquez 250344979
    Ivan Duque Marquez 37599351
    Ivan Duque Marquez 115164204
    Ivan Duque Marquez 369155414
    Ivan Duque Marquez 1582987716
    Ivan Duque Marquez 263359642
    Ivan Duque Marquez 1967155250
    Ivan Duque Marquez 182839829
    Ivan Duque Marquez 275703505
    Ivan Duque Marquez 182944118
    Ivan Duque Marquez 592618356
    Ivan Duque Marquez 88005891
    Ivan Duque Marquez 2241221
    Ivan Duque Marquez 124258289
    Ivan Duque Marquez 74866542
    Ivan Duque Marquez 554097029
    Ivan Duque Marquez 404712200
    Ivan Duque Marquez 492445162
    Ivan Duque Marquez 19654407
    Ivan Duque Marquez 127225115
    Ivan Duque Marquez 336365509
    Ivan Duque Marquez 16175706
    Ivan Duque Marquez 46981548
    Ivan Duque Marquez 867208034
    Ivan Duque Marquez 528933572
    Ivan Duque Marquez 184760559
    Ivan Duque Marquez 43929805
    Ivan Duque Marquez 2255984294
    Ivan Duque Marquez 138190882
    Ivan Duque Marquez 358245362
    Ivan Duque Marquez 198607213
    Ivan Duque Marquez 39531077
    Ivan Duque Marquez 586783065
    Ivan Duque Marquez 14681581
    Ivan Duque Marquez 2230695791
    Ivan Duque Marquez 607683379
    Ivan Duque Marquez 581054399
    Ivan Duque Marquez 1719300308
    Ivan Duque Marquez 162542782
    Ivan Duque Marquez 964661912
    Ivan Duque Marquez 133011518
    Ivan Duque Marquez 262349588
    Ivan Duque Marquez 1925200320
    Ivan Duque Marquez 184504231
    Ivan Duque Marquez 355090439
    Ivan Duque Marquez 473207162
    Ivan Duque Marquez 327553766
    Ivan Duque Marquez 276205442
    Ivan Duque Marquez 522627214
    Ivan Duque Marquez 296486839
    Ivan Duque Marquez 242638754
    Ivan Duque Marquez 134938656
    Ivan Duque Marquez 141352684
    Ivan Duque Marquez 198979489
    Ivan Duque Marquez 103712165
    Ivan Duque Marquez 1123542973
    Ivan Duque Marquez 414075229
    Ivan Duque Marquez 18138592
    Ivan Duque Marquez 49385956
    Ivan Duque Marquez 292248673
    Ivan Duque Marquez 191938697
    Ivan Duque Marquez 8273062
    Ivan Duque Marquez 292481960
    Ivan Duque Marquez 473298024
    Ivan Duque Marquez 191116947
    Ivan Duque Marquez 62708044
    Ivan Duque Marquez 15364107
    Ivan Duque Marquez 218179762
    Ivan Duque Marquez 1301761278
    Ivan Duque Marquez 262770233
    Ivan Duque Marquez 44740326
    Ivan Duque Marquez 250325596
    Ivan Duque Marquez 140140285
    Ivan Duque Marquez 2168004656
    Ivan Duque Marquez 408079793
    Ivan Duque Marquez 188569473
    Ivan Duque Marquez 309736267
    Ivan Duque Marquez 179255329
    Ivan Duque Marquez 702831737
    Ivan Duque Marquez 1965647552
    Ivan Duque Marquez 223988827
    Ivan Duque Marquez 2168667871
    Ivan Duque Marquez 184477052
    Ivan Duque Marquez 519486094
    Ivan Duque Marquez 191666204
    Ivan Duque Marquez 113671065
    Ivan Duque Marquez 506101484
    Ivan Duque Marquez 18539631
    Ivan Duque Marquez 16580053
    Ivan Duque Marquez 471475942
    Ivan Duque Marquez 38925280
    Ivan Duque Marquez 368458178
    Ivan Duque Marquez 361468994
    Ivan Duque Marquez 94752008
    Ivan Duque Marquez 105305259
    Ivan Duque Marquez 236902357
    Ivan Duque Marquez 50450033
    Ivan Duque Marquez 423270390
    Ivan Duque Marquez 108073880
    Ivan Duque Marquez 116000560
    Ivan Duque Marquez 281167135
    Ivan Duque Marquez 24035547
    Ivan Duque Marquez 33098495
    Ivan Duque Marquez 245436653
    Ivan Duque Marquez 153893935
    Ivan Duque Marquez 246261681
    Ivan Duque Marquez 19900431
    Ivan Duque Marquez 26571282
    Ivan Duque Marquez 1854751477
    Ivan Duque Marquez 123154143
    Ivan Duque Marquez 205996765
    Ivan Duque Marquez 498817723
    Ivan Duque Marquez 1486476924
    Ivan Duque Marquez 181970185
    Ivan Duque Marquez 15207459
    Ivan Duque Marquez 226535219
    Ivan Duque Marquez 90266988
    Ivan Duque Marquez 15163398
    Ivan Duque Marquez 176273714
    Ivan Duque Marquez 781024980
    Ivan Duque Marquez 1225813308
    Ivan Duque Marquez 122118209
    Ivan Duque Marquez 1092902960
    Ivan Duque Marquez 220545108
    Ivan Duque Marquez 60666629
    Ivan Duque Marquez 1855213146
    Ivan Duque Marquez 119192049
    Ivan Duque Marquez 136059193
    Ivan Duque Marquez 556613674
    Ivan Duque Marquez 50494032
    Ivan Duque Marquez 55983344
    Ivan Duque Marquez 102324906
    Ivan Duque Marquez 1532586613
    Ivan Duque Marquez 1864346425
    Ivan Duque Marquez 1115440213
    Ivan Duque Marquez 582286332
    Ivan Duque Marquez 239685030
    Ivan Duque Marquez 12583602
    Ivan Duque Marquez 133892427
    Ivan Duque Marquez 1358047412
    Ivan Duque Marquez 82766404
    Ivan Duque Marquez 183500927
    Ivan Duque Marquez 171999431
    Ivan Duque Marquez 96169325
    Ivan Duque Marquez 79350788
    Ivan Duque Marquez 27969594
    Ivan Duque Marquez 158865710
    Ivan Duque Marquez 129948248
    Ivan Duque Marquez 302865394
    Ivan Duque Marquez 81361075
    Ivan Duque Marquez 419007810
    Ivan Duque Marquez 1969623128
    Ivan Duque Marquez 35612573
    Ivan Duque Marquez 287372042
    Ivan Duque Marquez 341219345
    Ivan Duque Marquez 1449230779
    Ivan Duque Marquez 108286674
    Ivan Duque Marquez 149178822
    Ivan Duque Marquez 560469487
    Ivan Duque Marquez 174361486
    Ivan Duque Marquez 97452391
    Ivan Duque Marquez 56599191
    Ivan Duque Marquez 705484506
    Ivan Duque Marquez 47855400
    Ivan Duque Marquez 436127369
    Ivan Duque Marquez 64791701
    Ivan Duque Marquez 461743587
    Ivan Duque Marquez 150874377
    Ivan Duque Marquez 745646359
    Ivan Duque Marquez 52904760
    Ivan Duque Marquez 43105334
    Ivan Duque Marquez 142469128
    Ivan Duque Marquez 465909574
    Ivan Duque Marquez 237759006
    Ivan Duque Marquez 20456814
    Ivan Duque Marquez 14614643
    Ivan Duque Marquez 215244507
    Ivan Duque Marquez 196911174
    Ivan Duque Marquez 139974630
    Ivan Duque Marquez 70783321
    Ivan Duque Marquez 40052022
    Ivan Duque Marquez 974182970
    Ivan Duque Marquez 1558415358
    Ivan Duque Marquez 62375750
    Ivan Duque Marquez 186949520
    Ivan Duque Marquez 120805318
    Ivan Duque Marquez 702418713
    Ivan Duque Marquez 1694227904
    Ivan Duque Marquez 1119465374
    Ivan Duque Marquez 151979530
    Ivan Duque Marquez 105558471
    Ivan Duque Marquez 48462806
    Ivan Duque Marquez 45321910
    Ivan Duque Marquez 261822025
    Ivan Duque Marquez 403909017
    Ivan Duque Marquez 1901821194
    Ivan Duque Marquez 304664529
    Ivan Duque Marquez 526484956
    Ivan Duque Marquez 619617775
    Ivan Duque Marquez 309241093
    Ivan Duque Marquez 59981052
    Ivan Duque Marquez 178953137
    Ivan Duque Marquez 17425484
    Ivan Duque Marquez 135885534
    Ivan Duque Marquez 225228519
    Ivan Duque Marquez 1414140841
    Ivan Duque Marquez 68507533
    Ivan Duque Marquez 285551759
    Ivan Duque Marquez 273065180
    Ivan Duque Marquez 201363977
    Ivan Duque Marquez 85459979
    Ivan Duque Marquez 37750363
    Ivan Duque Marquez 1321310522
    Ivan Duque Marquez 22662733
    Ivan Duque Marquez 908980206
    Ivan Duque Marquez 96439320
    Ivan Duque Marquez 163133514
    Ivan Duque Marquez 220347362
    Ivan Duque Marquez 200998119
    Ivan Duque Marquez 181995906
    Ivan Duque Marquez 209841327
    Ivan Duque Marquez 932274440
    Ivan Duque Marquez 361871497
    Ivan Duque Marquez 142021639
    Ivan Duque Marquez 149128896
    Ivan Duque Marquez 68861723
    Ivan Duque Marquez 74005956
    Ivan Duque Marquez 246018434
    Ivan Duque Marquez 38804737
    Ivan Duque Marquez 226643596
    Ivan Duque Marquez 397444829
    Ivan Duque Marquez 244750033
    Ivan Duque Marquez 197153509
    Ivan Duque Marquez 241237382
    Ivan Duque Marquez 269918381
    Ivan Duque Marquez 494420269
    Ivan Duque Marquez 115412520
    Ivan Duque Marquez 206486600
    Ivan Duque Marquez 985698174
    Ivan Duque Marquez 281230760
    Ivan Duque Marquez 222456405
    Ivan Duque Marquez 152112161
    Ivan Duque Marquez 507579817
    Ivan Duque Marquez 20980846
    Ivan Duque Marquez 124926853
    Ivan Duque Marquez 256187433
    Ivan Duque Marquez 1596185450
    Ivan Duque Marquez 32211946
    Ivan Duque Marquez 285780822
    Ivan Duque Marquez 71359718
    Ivan Duque Marquez 329415263
    Ivan Duque Marquez 264397484
    Ivan Duque Marquez 286659264
    Ivan Duque Marquez 76192993
    Ivan Duque Marquez 251393299
    Ivan Duque Marquez 1686191076
    Ivan Duque Marquez 19654685
    Ivan Duque Marquez 1653863437
    Ivan Duque Marquez 143166984
    Ivan Duque Marquez 1620810084
    Ivan Duque Marquez 600031984
    Ivan Duque Marquez 1376073882
    Ivan Duque Marquez 525264466
    Ivan Duque Marquez 169222815
    Ivan Duque Marquez 934672914
    Ivan Duque Marquez 1134551575
    Ivan Duque Marquez 130599952
    Ivan Duque Marquez 49798228
    Ivan Duque Marquez 70546566
    Ivan Duque Marquez 108624065
    Ivan Duque Marquez 363649087
    Ivan Duque Marquez 844305397
    Ivan Duque Marquez 363253547
    Ivan Duque Marquez 306099659
    Ivan Duque Marquez 157815161
    Ivan Duque Marquez 50077268
    Ivan Duque Marquez 1644062768
    Ivan Duque Marquez 271694193
    Ivan Duque Marquez 177420965
    Ivan Duque Marquez 479693872
    Ivan Duque Marquez 457010909
    Ivan Duque Marquez 147993143
    Ivan Duque Marquez 69516296
    Ivan Duque Marquez 248918439
    Ivan Duque Marquez 349780099
    Ivan Duque Marquez 142726725
    Ivan Duque Marquez 38866099
    Ivan Duque Marquez 44171543
    Ivan Duque Marquez 192941442
    Ivan Duque Marquez 80119541
    Ivan Duque Marquez 194397716
    Ivan Duque Marquez 243741788
    Ivan Duque Marquez 569417451
    Ivan Duque Marquez 1608806714
    Ivan Duque Marquez 188100225
    Ivan Duque Marquez 14994805
    Ivan Duque Marquez 1128525852
    Ivan Duque Marquez 204283675
    Ivan Duque Marquez 1578069601
    Ivan Duque Marquez 1478062268
    Ivan Duque Marquez 612543896
    Ivan Duque Marquez 246410467
    Ivan Duque Marquez 563888749
    Ivan Duque Marquez 142636058
    Ivan Duque Marquez 222421020
    Ivan Duque Marquez 341200881
    Ivan Duque Marquez 282754422
    Ivan Duque Marquez 117031630
    Ivan Duque Marquez 90028622
    Ivan Duque Marquez 41292729
    Ivan Duque Marquez 915852500
    Ivan Duque Marquez 142269040
    Ivan Duque Marquez 80929199
    Ivan Duque Marquez 93237758
    Ivan Duque Marquez 348000278
    Ivan Duque Marquez 1072403917
    Ivan Duque Marquez 81244480
    Ivan Duque Marquez 154139936
    Ivan Duque Marquez 864276324
    Ivan Duque Marquez 63935827
    Ivan Duque Marquez 22179270
    Ivan Duque Marquez 125435771
    Ivan Duque Marquez 77929346
    Ivan Duque Marquez 29068397
    Ivan Duque Marquez 465983898
    Ivan Duque Marquez 540423877
    Ivan Duque Marquez 76454478
    Ivan Duque Marquez 198984928
    Ivan Duque Marquez 350540259
    Ivan Duque Marquez 91719949
    Ivan Duque Marquez 855742518
    Ivan Duque Marquez 297246001
    Ivan Duque Marquez 162570719
    Ivan Duque Marquez 186201086
    Ivan Duque Marquez 77753832
    Ivan Duque Marquez 64049591
    Ivan Duque Marquez 17449646
    Ivan Duque Marquez 19844693
    Ivan Duque Marquez 21090827
    Ivan Duque Marquez 60464113
    Ivan Duque Marquez 1586899753
    Ivan Duque Marquez 257581957
    Ivan Duque Marquez 182103541
    Ivan Duque Marquez 321753924
    Ivan Duque Marquez 1304751265
    Ivan Duque Marquez 57191937
    Ivan Duque Marquez 20951886
    Ivan Duque Marquez 393579542
    Ivan Duque Marquez 128000186
    Ivan Duque Marquez 33455089
    Ivan Duque Marquez 6855602
    Ivan Duque Marquez 514948178
    Ivan Duque Marquez 1563657512
    Ivan Duque Marquez 392428770
    Ivan Duque Marquez 221623773
    Ivan Duque Marquez 439409834
    Ivan Duque Marquez 1539878030
    Ivan Duque Marquez 148825438
    Ivan Duque Marquez 485710130
    Ivan Duque Marquez 186860316
    Ivan Duque Marquez 872466427
    Ivan Duque Marquez 582282658
    Ivan Duque Marquez 244218738
    Ivan Duque Marquez 48738001
    Ivan Duque Marquez 29968229
    Ivan Duque Marquez 145048222
    Ivan Duque Marquez 1519670276
    Ivan Duque Marquez 201398373
    Ivan Duque Marquez 44197786
    Ivan Duque Marquez 285128320
    Ivan Duque Marquez 1390576080
    Ivan Duque Marquez 301030562
    Ivan Duque Marquez 1514027215
    Ivan Duque Marquez 561376286
    Ivan Duque Marquez 449808523
    Ivan Duque Marquez 142035151
    Ivan Duque Marquez 219443317
    Ivan Duque Marquez 334375683
    Ivan Duque Marquez 306810852
    Ivan Duque Marquez 218240939
    Ivan Duque Marquez 186648242
    Ivan Duque Marquez 89600533
    Ivan Duque Marquez 463538502
    Ivan Duque Marquez 304615687
    Ivan Duque Marquez 258648811
    Ivan Duque Marquez 798918086
    Ivan Duque Marquez 272956932
    Ivan Duque Marquez 351726568
    Ivan Duque Marquez 295876773
    Ivan Duque Marquez 10253742
    Ivan Duque Marquez 803092813
    Ivan Duque Marquez 281588406
    Ivan Duque Marquez 150102770
    Ivan Duque Marquez 127925615
    Ivan Duque Marquez 15746247
    Ivan Duque Marquez 17041106
    Ivan Duque Marquez 390858322
    Ivan Duque Marquez 320099525
    Ivan Duque Marquez 295369276
    Ivan Duque Marquez 20539553
    Ivan Duque Marquez 900638310
    Ivan Duque Marquez 245795259
    Ivan Duque Marquez 85165861
    Ivan Duque Marquez 42954206
    Ivan Duque Marquez 1064320890
    Ivan Duque Marquez 236196162
    Ivan Duque Marquez 15143478
    Ivan Duque Marquez 20038221
    Ivan Duque Marquez 148496087
    Ivan Duque Marquez 37291805
    Ivan Duque Marquez 14353392
    Ivan Duque Marquez 25185308
    Ivan Duque Marquez 803262500
    Ivan Duque Marquez 335978208
    Ivan Duque Marquez 468794446
    Ivan Duque Marquez 138737516
    Ivan Duque Marquez 55002103
    Ivan Duque Marquez 135321834
    Ivan Duque Marquez 1080873181
    Ivan Duque Marquez 14050583
    Ivan Duque Marquez 32423136
    Ivan Duque Marquez 997629601
    Ivan Duque Marquez 107225267
    Ivan Duque Marquez 15125585
    Ivan Duque Marquez 116994659
    Ivan Duque Marquez 1330457336
    Ivan Duque Marquez 44196397
    Ivan Duque Marquez 556151596
    Ivan Duque Marquez 16303106
    Ivan Duque Marquez 20779255
    Ivan Duque Marquez 51837775
    Ivan Duque Marquez 142306651
    Ivan Duque Marquez 338386364
    Ivan Duque Marquez 1364930179
    Ivan Duque Marquez 221808649
    Ivan Duque Marquez 754212613
    Ivan Duque Marquez 26538229
    Ivan Duque Marquez 274321132
    Ivan Duque Marquez 272639130
    Ivan Duque Marquez 991745802
    Ivan Duque Marquez 12609292
    Ivan Duque Marquez 34042766
    Ivan Duque Marquez 1201567172
    Ivan Duque Marquez 16838443
    Ivan Duque Marquez 50056496
    Ivan Duque Marquez 64019370
    Ivan Duque Marquez 147750051
    Ivan Duque Marquez 430250670
    Ivan Duque Marquez 336116660
    Ivan Duque Marquez 236526490
    Ivan Duque Marquez 1437178938
    Ivan Duque Marquez 372862013
    Ivan Duque Marquez 124819655
    Ivan Duque Marquez 14677117
    Ivan Duque Marquez 40238982
    Ivan Duque Marquez 404292675
    Ivan Duque Marquez 16201819
    Ivan Duque Marquez 38614775
    Ivan Duque Marquez 71629877
    Ivan Duque Marquez 333958419
    Ivan Duque Marquez 112564528
    Ivan Duque Marquez 49723417
    Ivan Duque Marquez 78081806
    Ivan Duque Marquez 14378113
    Ivan Duque Marquez 1059273780
    Ivan Duque Marquez 384699845
    Ivan Duque Marquez 820235664
    

    Rate limit reached. Sleeping for: 730
    

    Ivan Duque Marquez 854291
    Ivan Duque Marquez 295779307
    Ivan Duque Marquez 9572932
    Ivan Duque Marquez 20870495
    Ivan Duque Marquez 132412567
    Ivan Duque Marquez 17015000
    Ivan Duque Marquez 34796669
    Ivan Duque Marquez 15027362
    Ivan Duque Marquez 1277763643
    Ivan Duque Marquez 498896007
    Ivan Duque Marquez 221539711
    Ivan Duque Marquez 7215612
    Ivan Duque Marquez 27121074
    Ivan Duque Marquez 26261464
    Ivan Duque Marquez 17325009
    Ivan Duque Marquez 16694698
    Ivan Duque Marquez 15320887
    Ivan Duque Marquez 382253381
    Ivan Duque Marquez 18887481
    Ivan Duque Marquez 19038395
    Ivan Duque Marquez 40932856
    Ivan Duque Marquez 83611099
    Ivan Duque Marquez 26857202
    Ivan Duque Marquez 31388829
    Ivan Duque Marquez 18028594
    Ivan Duque Marquez 130248995
    Ivan Duque Marquez 23847535
    Ivan Duque Marquez 19313711
    Ivan Duque Marquez 92346621
    Ivan Duque Marquez 22705078
    Ivan Duque Marquez 14292370
    Ivan Duque Marquez 19645791
    Ivan Duque Marquez 32211808
    Ivan Duque Marquez 51885045
    Ivan Duque Marquez 18310578
    Ivan Duque Marquez 17667607
    Ivan Duque Marquez 75302325
    Ivan Duque Marquez 749963
    Ivan Duque Marquez 254627275
    Ivan Duque Marquez 15754301
    Ivan Duque Marquez 280716675
    Ivan Duque Marquez 2735591
    Ivan Duque Marquez 17456146
    Ivan Duque Marquez 14165865
    Ivan Duque Marquez 316588374
    Ivan Duque Marquez 14514411
    Ivan Duque Marquez 56452935
    Ivan Duque Marquez 139171838
    Ivan Duque Marquez 20244611
    Ivan Duque Marquez 44373700
    Ivan Duque Marquez 40189206
    Ivan Duque Marquez 349601902
    Ivan Duque Marquez 105082141
    Ivan Duque Marquez 221032746
    Ivan Duque Marquez 81401876
    Ivan Duque Marquez 51586323
    Ivan Duque Marquez 163961519
    Ivan Duque Marquez 917549430
    Ivan Duque Marquez 30725771
    Ivan Duque Marquez 283284565
    Ivan Duque Marquez 64829924
    Ivan Duque Marquez 31969179
    Ivan Duque Marquez 202457700
    Ivan Duque Marquez 22589921
    Ivan Duque Marquez 1118809064
    Ivan Duque Marquez 1325254651
    Ivan Duque Marquez 132254028
    Ivan Duque Marquez 291395954
    Ivan Duque Marquez 535530114
    Ivan Duque Marquez 125749584
    Ivan Duque Marquez 403180170
    Ivan Duque Marquez 1317200264
    Ivan Duque Marquez 69211694
    Ivan Duque Marquez 459411454
    Ivan Duque Marquez 363258643
    Ivan Duque Marquez 160767992
    Ivan Duque Marquez 198244461
    Ivan Duque Marquez 1053320558
    Ivan Duque Marquez 1252968522
    Ivan Duque Marquez 52055757
    Ivan Duque Marquez 22758370
    Ivan Duque Marquez 516536406
    Ivan Duque Marquez 325071911
    Ivan Duque Marquez 200541814
    Ivan Duque Marquez 514452524
    Ivan Duque Marquez 75733989
    Ivan Duque Marquez 6342542
    Ivan Duque Marquez 140985149
    Ivan Duque Marquez 390740202
    Ivan Duque Marquez 35626747
    Ivan Duque Marquez 454609812
    Ivan Duque Marquez 53735304
    Ivan Duque Marquez 538520328
    Ivan Duque Marquez 701956728
    Ivan Duque Marquez 20629893
    Ivan Duque Marquez 16814740
    Ivan Duque Marquez 210992598
    Ivan Duque Marquez 500704345
    Ivan Duque Marquez 15112070
    Ivan Duque Marquez 11347122
    Ivan Duque Marquez 1250447473
    Ivan Duque Marquez 356314280
    Ivan Duque Marquez 46398361
    Ivan Duque Marquez 60483605
    Ivan Duque Marquez 11424872
    Ivan Duque Marquez 1206630559
    Ivan Duque Marquez 52647281
    Ivan Duque Marquez 18803080
    Ivan Duque Marquez 54569666
    Ivan Duque Marquez 34535086
    Ivan Duque Marquez 203588966
    Ivan Duque Marquez 52958439
    Ivan Duque Marquez 128362483
    Ivan Duque Marquez 266893089
    Ivan Duque Marquez 58821418
    Ivan Duque Marquez 124492052
    Ivan Duque Marquez 44151017
    Ivan Duque Marquez 89707185
    Ivan Duque Marquez 172368909
    Ivan Duque Marquez 105140460
    Ivan Duque Marquez 158145014
    Ivan Duque Marquez 595866476
    Ivan Duque Marquez 1076761879
    Ivan Duque Marquez 1081127634
    Ivan Duque Marquez 1086208248
    Ivan Duque Marquez 568552766
    Ivan Duque Marquez 257065044
    Ivan Duque Marquez 68824160
    Ivan Duque Marquez 48311642
    Ivan Duque Marquez 50743581
    Ivan Duque Marquez 23001622
    Ivan Duque Marquez 620473618
    Ivan Duque Marquez 338472735
    Ivan Duque Marquez 1071934909
    Ivan Duque Marquez 551593127
    Ivan Duque Marquez 142830837
    Ivan Duque Marquez 535313269
    Ivan Duque Marquez 496338655
    Ivan Duque Marquez 576557103
    Ivan Duque Marquez 1040024600
    Ivan Duque Marquez 277717911
    Ivan Duque Marquez 112921297
    Ivan Duque Marquez 39648834
    Ivan Duque Marquez 17068185
    Ivan Duque Marquez 820381933
    Ivan Duque Marquez 106280597
    Ivan Duque Marquez 535681046
    Ivan Duque Marquez 206036173
    Ivan Duque Marquez 71183932
    Ivan Duque Marquez 563690724
    Ivan Duque Marquez 166967644
    Ivan Duque Marquez 65135314
    Ivan Duque Marquez 514685869
    Ivan Duque Marquez 262482092
    Ivan Duque Marquez 221158140
    Ivan Duque Marquez 985826540
    Ivan Duque Marquez 16439573
    Ivan Duque Marquez 468436674
    Ivan Duque Marquez 599432552
    Ivan Duque Marquez 139105222
    Ivan Duque Marquez 848402348
    Ivan Duque Marquez 386682529
    Ivan Duque Marquez 185859540
    Ivan Duque Marquez 488685674
    Ivan Duque Marquez 22029874
    Ivan Duque Marquez 57460086
    Ivan Duque Marquez 112412293
    Ivan Duque Marquez 107882599
    Ivan Duque Marquez 622082899
    Ivan Duque Marquez 40798868
    Ivan Duque Marquez 212051287
    Ivan Duque Marquez 123112482
    Ivan Duque Marquez 49979823
    Ivan Duque Marquez 586940222
    Ivan Duque Marquez 73206956
    Ivan Duque Marquez 144959113
    Ivan Duque Marquez 35423350
    Ivan Duque Marquez 891349478
    Ivan Duque Marquez 62945553
    Ivan Duque Marquez 261714419
    Ivan Duque Marquez 3376511
    Ivan Duque Marquez 36087400
    Ivan Duque Marquez 315453658
    Ivan Duque Marquez 607598099
    Ivan Duque Marquez 78345713
    Ivan Duque Marquez 508097690
    Ivan Duque Marquez 14780915
    Ivan Duque Marquez 16029092
    Ivan Duque Marquez 301526644
    Ivan Duque Marquez 249360165
    Ivan Duque Marquez 184835716
    Ivan Duque Marquez 778466498
    Ivan Duque Marquez 22451778
    Ivan Duque Marquez 520571895
    Ivan Duque Marquez 575615374
    Ivan Duque Marquez 575713173
    Ivan Duque Marquez 246456840
    Ivan Duque Marquez 178717090
    Ivan Duque Marquez 155428489
    Ivan Duque Marquez 50360725
    Ivan Duque Marquez 109585850
    Ivan Duque Marquez 21406335
    Ivan Duque Marquez 43395943
    Ivan Duque Marquez 35013719
    Ivan Duque Marquez 40533752
    Ivan Duque Marquez 114565978
    Ivan Duque Marquez 58650958
    Ivan Duque Marquez 18079284
    Ivan Duque Marquez 43372273
    Ivan Duque Marquez 56724999
    Ivan Duque Marquez 40098182
    Ivan Duque Marquez 94409405
    Ivan Duque Marquez 25115479
    Ivan Duque Marquez 57148729
    Ivan Duque Marquez 471177579
    Ivan Duque Marquez 212059467
    Ivan Duque Marquez 712597123
    Ivan Duque Marquez 15384023
    Ivan Duque Marquez 59459771
    Ivan Duque Marquez 410228042
    Ivan Duque Marquez 104861330
    Ivan Duque Marquez 139508438
    Ivan Duque Marquez 268322810
    Ivan Duque Marquez 38227815
    Ivan Duque Marquez 256108484
    Ivan Duque Marquez 74763503
    Ivan Duque Marquez 69419282
    Ivan Duque Marquez 114852120
    Ivan Duque Marquez 125399012
    Ivan Duque Marquez 133128555
    Ivan Duque Marquez 17805179
    Ivan Duque Marquez 332898591
    Ivan Duque Marquez 211376476
    Ivan Duque Marquez 417886540
    Ivan Duque Marquez 565490620
    Ivan Duque Marquez 15134782
    Ivan Duque Marquez 294021277
    Ivan Duque Marquez 609145727
    Ivan Duque Marquez 131183505
    Ivan Duque Marquez 138922361
    Ivan Duque Marquez 181518747
    Ivan Duque Marquez 631580827
    Ivan Duque Marquez 480346290
    Ivan Duque Marquez 621914065
    Ivan Duque Marquez 16814640
    Ivan Duque Marquez 1091241
    Ivan Duque Marquez 35535847
    Ivan Duque Marquez 37813432
    Ivan Duque Marquez 47846695
    Ivan Duque Marquez 425518440
    Ivan Duque Marquez 26152492
    Ivan Duque Marquez 592887786
    Ivan Duque Marquez 96679277
    Ivan Duque Marquez 135252488
    Ivan Duque Marquez 49304503
    Ivan Duque Marquez 42504123
    Ivan Duque Marquez 34641036
    Ivan Duque Marquez 16676396
    Ivan Duque Marquez 66657467
    Ivan Duque Marquez 17813487
    Ivan Duque Marquez 253315622
    Ivan Duque Marquez 57174405
    Ivan Duque Marquez 216695058
    Ivan Duque Marquez 104974333
    Ivan Duque Marquez 481778007
    Ivan Duque Marquez 77694285
    Ivan Duque Marquez 90558638
    Ivan Duque Marquez 224400256
    Ivan Duque Marquez 34188939
    Ivan Duque Marquez 45580261
    Ivan Duque Marquez 26640415
    Ivan Duque Marquez 466531652
    Ivan Duque Marquez 56696814
    Ivan Duque Marquez 595653152
    Ivan Duque Marquez 246462556
    Ivan Duque Marquez 75069067
    Ivan Duque Marquez 299725755
    Ivan Duque Marquez 16163059
    Ivan Duque Marquez 169235632
    Ivan Duque Marquez 512066728
    Ivan Duque Marquez 130146107
    Ivan Duque Marquez 19736492
    Ivan Duque Marquez 248330771
    Ivan Duque Marquez 529380538
    Ivan Duque Marquez 27899907
    Ivan Duque Marquez 39798747
    Ivan Duque Marquez 110815843
    Ivan Duque Marquez 110812131
    Ivan Duque Marquez 24076692
    Ivan Duque Marquez 515850314
    Ivan Duque Marquez 515889102
    Ivan Duque Marquez 515997524
    Ivan Duque Marquez 489772745
    Ivan Duque Marquez 223849532
    Ivan Duque Marquez 69320329
    Ivan Duque Marquez 95000446
    Ivan Duque Marquez 407038417
    Ivan Duque Marquez 32166535
    Ivan Duque Marquez 143649000
    Ivan Duque Marquez 216130843
    Ivan Duque Marquez 491005739
    Ivan Duque Marquez 15315979
    Ivan Duque Marquez 28618779
    Ivan Duque Marquez 25797905
    Ivan Duque Marquez 84365525
    Ivan Duque Marquez 74286565
    Ivan Duque Marquez 142250577
    Ivan Duque Marquez 434544048
    Ivan Duque Marquez 47753979
    Ivan Duque Marquez 36278714
    Ivan Duque Marquez 326188957
    Ivan Duque Marquez 33157684
    Ivan Duque Marquez 479584334
    Ivan Duque Marquez 387519542
    Ivan Duque Marquez 21137979
    Ivan Duque Marquez 26551513
    Ivan Duque Marquez 174228676
    Ivan Duque Marquez 59540721
    Ivan Duque Marquez 15212604
    Ivan Duque Marquez 303811814
    Ivan Duque Marquez 25316967
    Ivan Duque Marquez 364788176
    Ivan Duque Marquez 150658337
    Ivan Duque Marquez 142884010
    Ivan Duque Marquez 16679508
    Ivan Duque Marquez 15663355
    Ivan Duque Marquez 187010355
    Ivan Duque Marquez 19164943
    Ivan Duque Marquez 53549197
    Ivan Duque Marquez 148072560
    Ivan Duque Marquez 315768853
    Ivan Duque Marquez 17093617
    Ivan Duque Marquez 7540212
    Ivan Duque Marquez 76056805
    Ivan Duque Marquez 20439102
    Ivan Duque Marquez 143862464
    Ivan Duque Marquez 97530222
    Ivan Duque Marquez 132886520
    Ivan Duque Marquez 21108916
    Ivan Duque Marquez 89211580
    Ivan Duque Marquez 49758266
    Ivan Duque Marquez 275052281
    Ivan Duque Marquez 74776409
    Ivan Duque Marquez 101848693
    Ivan Duque Marquez 15463671
    Ivan Duque Marquez 36677982
    Ivan Duque Marquez 36378198
    Ivan Duque Marquez 14085040
    Ivan Duque Marquez 6790442
    Ivan Duque Marquez 5225991
    Ivan Duque Marquez 15625377
    Ivan Duque Marquez 16298447
    Ivan Duque Marquez 17057271
    Ivan Duque Marquez 16650023
    Ivan Duque Marquez 16568227
    Ivan Duque Marquez 15057943
    Ivan Duque Marquez 19066345
    Ivan Duque Marquez 12804422
    Ivan Duque Marquez 20217658
    Ivan Duque Marquez 14647570
    Ivan Duque Marquez 53184098
    Ivan Duque Marquez 126447573
    Ivan Duque Marquez 47399813
    Ivan Duque Marquez 14289945
    Ivan Duque Marquez 212228906
    Ivan Duque Marquez 28642247
    Ivan Duque Marquez 14199378
    Ivan Duque Marquez 85606078
    Ivan Duque Marquez 97066277
    Ivan Duque Marquez 111691454
    Ivan Duque Marquez 431790201
    Ivan Duque Marquez 200196319
    Ivan Duque Marquez 1436461
    Ivan Duque Marquez 15723290
    Ivan Duque Marquez 20182089
    Ivan Duque Marquez 33933259
    Ivan Duque Marquez 21303235
    Ivan Duque Marquez 59145948
    Ivan Duque Marquez 42888442
    Ivan Duque Marquez 272066759
    Ivan Duque Marquez 4254301
    Ivan Duque Marquez 12998402
    Ivan Duque Marquez 22630002
    Ivan Duque Marquez 20029318
    Ivan Duque Marquez 12906
    Ivan Duque Marquez 20551303
    Ivan Duque Marquez 105643587
    Ivan Duque Marquez 19816859
    Ivan Duque Marquez 21744554
    Ivan Duque Marquez 19927627
    Ivan Duque Marquez 60628575
    Ivan Duque Marquez 17171111
    Ivan Duque Marquez 408703977
    Ivan Duque Marquez 11855772
    Ivan Duque Marquez 22545756
    Ivan Duque Marquez 7152572
    Ivan Duque Marquez 19386622
    Ivan Duque Marquez 14858856
    Ivan Duque Marquez 304909941
    Ivan Duque Marquez 246393171
    Ivan Duque Marquez 211263022
    Ivan Duque Marquez 39632552
    Ivan Duque Marquez 19673700
    Ivan Duque Marquez 14559745
    Ivan Duque Marquez 21453086
    Ivan Duque Marquez 109294940
    Ivan Duque Marquez 95332670
    Ivan Duque Marquez 36352562
    Ivan Duque Marquez 33674236
    Ivan Duque Marquez 57383574
    Ivan Duque Marquez 41456486
    Ivan Duque Marquez 254274083
    Ivan Duque Marquez 85603854
    Ivan Duque Marquez 14469949
    Ivan Duque Marquez 105598603
    Ivan Duque Marquez 172814396
    Ivan Duque Marquez 18510558
    Ivan Duque Marquez 344726222
    Ivan Duque Marquez 164675820
    Ivan Duque Marquez 44135322
    Ivan Duque Marquez 16581604
    Ivan Duque Marquez 214101291
    Ivan Duque Marquez 18178284
    Ivan Duque Marquez 271970590
    Ivan Duque Marquez 41648873
    Ivan Duque Marquez 32128783
    Ivan Duque Marquez 18686907
    Ivan Duque Marquez 41742794
    Ivan Duque Marquez 356872253
    Ivan Duque Marquez 331803536
    Ivan Duque Marquez 14375609
    Ivan Duque Marquez 34731203
    Ivan Duque Marquez 9096592
    Ivan Duque Marquez 370380915
    Ivan Duque Marquez 344459667
    Ivan Duque Marquez 313702107
    Ivan Duque Marquez 60308942
    Ivan Duque Marquez 46200798
    Ivan Duque Marquez 133945128
    Ivan Duque Marquez 46190010
    Ivan Duque Marquez 343447873
    Ivan Duque Marquez 27570569
    Ivan Duque Marquez 242730842
    Ivan Duque Marquez 286441121
    Ivan Duque Marquez 59157393
    Ivan Duque Marquez 19923515
    Ivan Duque Marquez 138814032
    Ivan Duque Marquez 98501655
    Ivan Duque Marquez 209780362
    Ivan Duque Marquez 151190865
    Ivan Duque Marquez 59915378
    Ivan Duque Marquez 44409004
    Ivan Duque Marquez 57986415
    Ivan Duque Marquez 16664681
    Ivan Duque Marquez 66458240
    Ivan Duque Marquez 54972010
    Ivan Duque Marquez 380648579
    Ivan Duque Marquez 35773039
    Ivan Duque Marquez 7348612
    Ivan Duque Marquez 87818409
    Ivan Duque Marquez 156775795
    Ivan Duque Marquez 373416209
    Ivan Duque Marquez 131574396
    Ivan Duque Marquez 193879623
    Ivan Duque Marquez 187317854
    Ivan Duque Marquez 14437914
    Ivan Duque Marquez 12133382
    Ivan Duque Marquez 15164565
    Ivan Duque Marquez 271452947
    Ivan Duque Marquez 66814930
    Ivan Duque Marquez 50354243
    Ivan Duque Marquez 111933542
    Ivan Duque Marquez 52536992
    Ivan Duque Marquez 19534873
    Ivan Duque Marquez 203560532
    Ivan Duque Marquez 296409480
    Ivan Duque Marquez 14940354
    Ivan Duque Marquez 17071048
    Ivan Duque Marquez 111339670
    Ivan Duque Marquez 7712452
    Ivan Duque Marquez 44199801
    Ivan Duque Marquez 18622869
    Ivan Duque Marquez 388555493
    Ivan Duque Marquez 312887235
    Ivan Duque Marquez 51999718
    Ivan Duque Marquez 266610899
    Ivan Duque Marquez 67788043
    Ivan Duque Marquez 24376343
    Ivan Duque Marquez 19697415
    Ivan Duque Marquez 37962817
    Ivan Duque Marquez 18812572
    Ivan Duque Marquez 337783129
    Ivan Duque Marquez 168303922
    Ivan Duque Marquez 91488267
    Ivan Duque Marquez 110861460
    Ivan Duque Marquez 244655353
    Ivan Duque Marquez 262872637
    Ivan Duque Marquez 20560294
    Ivan Duque Marquez 135996804
    Ivan Duque Marquez 127073570
    Ivan Duque Marquez 127059349
    Ivan Duque Marquez 86331057
    Ivan Duque Marquez 174693068
    Ivan Duque Marquez 183308316
    Ivan Duque Marquez 70363243
    Ivan Duque Marquez 28058878
    Ivan Duque Marquez 117942584
    Ivan Duque Marquez 149281495
    Ivan Duque Marquez 250265046
    Ivan Duque Marquez 146877835
    Ivan Duque Marquez 127752242
    Ivan Duque Marquez 213162575
    Ivan Duque Marquez 64521433
    Ivan Duque Marquez 124355265
    Ivan Duque Marquez 50769997
    Ivan Duque Marquez 185173076
    Ivan Duque Marquez 270684458
    Ivan Duque Marquez 40282700
    Ivan Duque Marquez 49241232
    Ivan Duque Marquez 185763733
    Ivan Duque Marquez 262814659
    Ivan Duque Marquez 15432218
    Ivan Duque Marquez 15308469
    Ivan Duque Marquez 135566260
    Ivan Duque Marquez 36821727
    Ivan Duque Marquez 143285665
    Ivan Duque Marquez 147734376
    Ivan Duque Marquez 18726043
    Ivan Duque Marquez 13784642
    Ivan Duque Marquez 36743910
    Ivan Duque Marquez 115441158
    Ivan Duque Marquez 189376144
    Ivan Duque Marquez 33792634
    Ivan Duque Marquez 21119632
    Ivan Duque Marquez 12804862
    Ivan Duque Marquez 20455625
    Ivan Duque Marquez 14287094
    Ivan Duque Marquez 73190286
    Ivan Duque Marquez 38507478
    Ivan Duque Marquez 16833653
    Ivan Duque Marquez 8632782
    Ivan Duque Marquez 46064420
    Ivan Duque Marquez 133633770
    Ivan Duque Marquez 51143631
    Ivan Duque Marquez 26697854
    Ivan Duque Marquez 119360445
    Ivan Duque Marquez 205280479
    Ivan Duque Marquez 17061263
    Ivan Duque Marquez 68034431
    Ivan Duque Marquez 61235774
    Ivan Duque Marquez 92399925
    Ivan Duque Marquez 7996082
    Ivan Duque Marquez 17485551
    Ivan Duque Marquez 27708897
    Ivan Duque Marquez 71294756
    Ivan Duque Marquez 110213431
    Ivan Duque Marquez 93957809
    Ivan Duque Marquez 64498695
    Ivan Duque Marquez 42226885
    Ivan Duque Marquez 134995285
    Ivan Duque Marquez 14499829
    Ivan Duque Marquez 15880642
    Ivan Duque Marquez 18576537
    Ivan Duque Marquez 24506246
    Ivan Duque Marquez 5520952
    Ivan Duque Marquez 163928038
    Ivan Duque Marquez 13201312
    Ivan Duque Marquez 19649135
    Ivan Duque Marquez 144376833
    Ivan Duque Marquez 61731614
    Ivan Duque Marquez 156651229
    Ivan Duque Marquez 81972948
    Ivan Duque Marquez 16954241
    Ivan Duque Marquez 10880202
    Ivan Duque Marquez 33669915
    Ivan Duque Marquez 243634290
    Ivan Duque Marquez 148517828
    Ivan Duque Marquez 85289376
    Ivan Duque Marquez 214896834
    Ivan Duque Marquez 208155240
    Ivan Duque Marquez 33884545
    Ivan Duque Marquez 16012783
    Ivan Duque Marquez 170714191
    Ivan Duque Marquez 52819651
    Ivan Duque Marquez 2467791
    Ivan Duque Marquez 44815900
    Ivan Duque Marquez 109646676
    Ivan Duque Marquez 108717093
    Ivan Duque Marquez 17471979
    Ivan Duque Marquez 92997339
    Ivan Duque Marquez 142027267
    Ivan Duque Marquez 164304654
    Ivan Duque Marquez 14857525
    Ivan Duque Marquez 25950355
    Ivan Duque Marquez 16111963
    Ivan Duque Marquez 18438933
    Ivan Duque Marquez 33039483
    Ivan Duque Marquez 13623532
    Ivan Duque Marquez 142849205
    Ivan Duque Marquez 179722950
    Ivan Duque Marquez 15823594
    Ivan Duque Marquez 17965523
    Ivan Duque Marquez 20596281
    Ivan Duque Marquez 18509466
    Ivan Duque Marquez 120176950
    Ivan Duque Marquez 46804450
    Ivan Duque Marquez 212320989
    Ivan Duque Marquez 41821987
    Ivan Duque Marquez 19236074
    Ivan Duque Marquez 52558480
    Ivan Duque Marquez 101864647
    Ivan Duque Marquez 175806207
    Ivan Duque Marquez 39657191
    Ivan Duque Marquez 12044602
    Ivan Duque Marquez 12144232
    Ivan Duque Marquez 112521824
    Ivan Duque Marquez 47288005
    Ivan Duque Marquez 229880392
    Ivan Duque Marquez 15212246
    Ivan Duque Marquez 20518867
    Ivan Duque Marquez 14304714
    Ivan Duque Marquez 27539545
    Ivan Duque Marquez 15862891
    Ivan Duque Marquez 12925072
    Ivan Duque Marquez 27707080
    Ivan Duque Marquez 10778572
    Ivan Duque Marquez 44706837
    Ivan Duque Marquez 21312469
    Ivan Duque Marquez 8496762
    Ivan Duque Marquez 182479169
    Ivan Duque Marquez 17243582
    Ivan Duque Marquez 15342208
    Ivan Duque Marquez 26579339
    Ivan Duque Marquez 18653226
    Ivan Duque Marquez 19113374
    Ivan Duque Marquez 20818801
    Ivan Duque Marquez 15173291
    Ivan Duque Marquez 16146731
    Ivan Duque Marquez 18225966
    Ivan Duque Marquez 14182620
    Ivan Duque Marquez 19621110
    Ivan Duque Marquez 68800800
    Ivan Duque Marquez 784912
    Ivan Duque Marquez 717313
    Ivan Duque Marquez 37570179
    Ivan Duque Marquez 13348
    Ivan Duque Marquez 64508047
    Ivan Duque Marquez 7905122
    Ivan Duque Marquez 5746452
    Ivan Duque Marquez 98132850
    Ivan Duque Marquez 14662354
    Ivan Duque Marquez 6149912
    Ivan Duque Marquez 12
    Ivan Duque Marquez 139121148
    Ivan Duque Marquez 17390324
    Ivan Duque Marquez 46671396
    Ivan Duque Marquez 5120691
    Ivan Duque Marquez 150565967
    Ivan Duque Marquez 91935208
    Ivan Duque Marquez 41268564
    Ivan Duque Marquez 17889970
    Ivan Duque Marquez 28403766
    Ivan Duque Marquez 34954224
    Ivan Duque Marquez 91916987
    Ivan Duque Marquez 184590625
    Ivan Duque Marquez 7684882
    Ivan Duque Marquez 116763916
    Ivan Duque Marquez 99349334
    Ivan Duque Marquez 17967925
    Ivan Duque Marquez 16348549
    Ivan Duque Marquez 20729766
    Ivan Duque Marquez 1917731
    Ivan Duque Marquez 1947301
    Ivan Duque Marquez 21619519
    Ivan Duque Marquez 21350494
    Ivan Duque Marquez 37926315
    Ivan Duque Marquez 20609518
    Ivan Duque Marquez 22685200
    Ivan Duque Marquez 21312378
    Ivan Duque Marquez 17163265
    Ivan Duque Marquez 159904799
    Ivan Duque Marquez 17179368
    Ivan Duque Marquez 816653
    Ivan Duque Marquez 15667291
    Ivan Duque Marquez 48705707
    Ivan Duque Marquez 8161232
    Ivan Duque Marquez 19177501
    Ivan Duque Marquez 3416421
    Ivan Duque Marquez 69181624
    Ivan Duque Marquez 15861355
    Ivan Duque Marquez 18949512
    Ivan Duque Marquez 15135214
    Ivan Duque Marquez 27860681
    Ivan Duque Marquez 29994840
    Ivan Duque Marquez 23484039
    Ivan Duque Marquez 17820947
    Ivan Duque Marquez 18481050
    Ivan Duque Marquez 85921271
    Ivan Duque Marquez 84364416
    Ivan Duque Marquez 105235530
    Ivan Duque Marquez 18083786
    Ivan Duque Marquez 25098482
    Ivan Duque Marquez 16511394
    Ivan Duque Marquez 35262030
    Ivan Duque Marquez 148529707
    Ivan Duque Marquez 146095589
    Ivan Duque Marquez 15072071
    Ivan Duque Marquez 158289900
    Ivan Duque Marquez 58550415
    Ivan Duque Marquez 20280065
    Ivan Duque Marquez 20715956
    Ivan Duque Marquez 21305239
    Ivan Duque Marquez 21114659
    Ivan Duque Marquez 17469492
    Ivan Duque Marquez 54311364
    Ivan Duque Marquez 59736898
    Ivan Duque Marquez 111416652
    Ivan Duque Marquez 61023448
    Ivan Duque Marquez 16955870
    Ivan Duque Marquez 14514804
    Ivan Duque Marquez 10228272
    Ivan Duque Marquez 33522604
    Ivan Duque Marquez 1049171
    Ivan Duque Marquez 41814169
    Ivan Duque Marquez 19224439
    Ivan Duque Marquez 17044207
    Ivan Duque Marquez 32493647
    Ivan Duque Marquez 39511166
    Ivan Duque Marquez 7259302
    Ivan Duque Marquez 3108351
    Ivan Duque Marquez 20108560
    Ivan Duque Marquez 140114710
    Ivan Duque Marquez 19289284
    Ivan Duque Marquez 742143
    Ivan Duque Marquez 5402612
    Ivan Duque Marquez 36843988
    Ivan Duque Marquez 20214495
    Ivan Duque Marquez 20032100
    Ivan Duque Marquez 34713362
    Ivan Duque Marquez 51241574
    Ivan Duque Marquez 21786831
    Ivan Duque Marquez 14800270
    Ivan Duque Marquez 64839766
    Ivan Duque Marquez 18401107
    Ivan Duque Marquez 14677919
    Ivan Duque Marquez 54730258
    Ivan Duque Marquez 1434251
    Ivan Duque Marquez 11178902
    Ivan Duque Marquez 19553409
    Ivan Duque Marquez 17074440
    Ivan Duque Marquez 73181712
    Ivan Duque Marquez 15675138
    Ivan Duque Marquez 9300262
    Ivan Duque Marquez 60919240
    Ivan Duque Marquez 27901418
    Ivan Duque Marquez 19394188
    Ivan Duque Marquez 44335525
    Ivan Duque Marquez 14246001
    Ivan Duque Marquez 14511951
    Ivan Duque Marquez 14075928
    Ivan Duque Marquez 20608910
    Ivan Duque Marquez 428333
    Ivan Duque Marquez 14224719
    Ivan Duque Marquez 14159148
    Ivan Duque Marquez 17220934
    Ivan Duque Marquez 16129920
    Ivan Duque Marquez 113420831
    Ivan Duque Marquez 818927131883356161
    Ivan Duque Marquez 24705126
    Ivan Duque Marquez 15224867
    Ivan Duque Marquez 15416505
    Ivan Duque Marquez 21982720
    Ivan Duque Marquez 26792275
    Ivan Duque Marquez 10032112
    Ivan Duque Marquez 15174477
    Ivan Duque Marquez 17006157
    Ivan Duque Marquez 15827269
    Ivan Duque Marquez 50393960
    Ivan Duque Marquez 39585367
    Ivan Duque Marquez 37758638
    Ivan Duque Marquez 64291532
    Ivan Duque Marquez 65493023
    Ivan Duque Marquez 61097151
    Ivan Duque Marquez 39313353
    Ivan Duque Marquez 16423109
    Ivan Duque Marquez 813286
    Ivan Duque Marquez 14293310
    Ivan Duque Marquez 16866617
    Ivan Duque Marquez 15460048
    Ivan Duque Marquez 17369110
    Ivan Duque Marquez 5694822
    Ivan Duque Marquez 24894213
    Ivan Duque Marquez 18036441
    Ivan Duque Marquez 19037859
    Ivan Duque Marquez 19606528
    Ivan Duque Marquez 21260160
    Ivan Duque Marquez 15168790
    Ivan Duque Marquez 22642788
    Ivan Duque Marquez 49279876
    Ivan Duque Marquez 71306470
    Ivan Duque Marquez 23088177
    Ivan Duque Marquez 17899109
    Ivan Duque Marquez 19543987
    Ivan Duque Marquez 35810531
    Ivan Duque Marquez 822215673812119553
    Ivan Duque Marquez 30313925
    Ivan Duque Marquez 5988062
    Ivan Duque Marquez 47005158
    Ivan Duque Marquez 807095
    Ivan Duque Marquez 24572785
    Ivan Duque Marquez 22053725
    Ivan Duque Marquez 14700316
    Ivan Duque Marquez 14603515
    Ivan Duque Marquez 16683014
    Ivan Duque Marquez 15728161
    Ivan Duque Marquez 57700256
    Ivan Duque Marquez 27081406
    Ivan Duque Marquez 2884771
    Ivan Duque Marquez 17004618
    Ivan Duque Marquez 18170896
    Ivan Duque Marquez 20479813
    Ivan Duque Marquez 49005215
    Ivan Duque Marquez 25927019
    Ivan Duque Marquez 14238967
    German Vargas Lleras 126975727
    German Vargas Lleras 3525569663
    German Vargas Lleras 252134272
    German Vargas Lleras 65967307
    German Vargas Lleras 20801337
    German Vargas Lleras 150444438
    German Vargas Lleras 260894276
    German Vargas Lleras 35013719
    German Vargas Lleras 622082899
    German Vargas Lleras 47753979
    German Vargas Lleras 67654599
    German Vargas Lleras 27570569
    German Vargas Lleras 17813487
    German Vargas Lleras 3401638840
    German Vargas Lleras 626592458
    German Vargas Lleras 1242282247
    German Vargas Lleras 1563679326
    German Vargas Lleras 48144146
    German Vargas Lleras 77614042
    German Vargas Lleras 486104564
    German Vargas Lleras 76664119
    German Vargas Lleras 48373749
    German Vargas Lleras 443078426
    German Vargas Lleras 295794437
    German Vargas Lleras 858741475
    German Vargas Lleras 358887972
    German Vargas Lleras 1879791901
    German Vargas Lleras 218621414
    German Vargas Lleras 2272438273
    German Vargas Lleras 953849000
    German Vargas Lleras 74236828
    German Vargas Lleras 574669533
    German Vargas Lleras 48500427
    German Vargas Lleras 59857894
    German Vargas Lleras 76743724
    German Vargas Lleras 319050168
    German Vargas Lleras 607619809
    German Vargas Lleras 293677912
    German Vargas Lleras 91488267
    German Vargas Lleras 32211946
    German Vargas Lleras 126204564
    German Vargas Lleras 242730842
    German Vargas Lleras 64791701
    German Vargas Lleras 253315622
    German Vargas Lleras 300815030
    German Vargas Lleras 2400080066
    German Vargas Lleras 231803432
    German Vargas Lleras 14050583
    German Vargas Lleras 135321834
    German Vargas Lleras 286942832
    German Vargas Lleras 601163523
    German Vargas Lleras 59459771
    German Vargas Lleras 286418059
    German Vargas Lleras 900542028752330754
    German Vargas Lleras 150874377
    German Vargas Lleras 770662232183144449
    German Vargas Lleras 295876773
    German Vargas Lleras 127925615
    German Vargas Lleras 814267892
    German Vargas Lleras 346586565
    German Vargas Lleras 44682937
    German Vargas Lleras 64839766
    German Vargas Lleras 52819651
    German Vargas Lleras 9633802
    German Vargas Lleras 79585327
    German Vargas Lleras 18079284
    German Vargas Lleras 20560294
    German Vargas Lleras 19236074
    Juan Manuel Santos 847591188332990466
    Juan Manuel Santos 132767249
    Juan Manuel Santos 1206515077
    Juan Manuel Santos 268322810
    Juan Manuel Santos 49849732
    Juan Manuel Santos 276722892
    Juan Manuel Santos 190334558
    Juan Manuel Santos 634645018
    Juan Manuel Santos 821461623189671937
    

    Rate limit reached. Sleeping for: 718
    

    Juan Manuel Santos 286441121
    Juan Manuel Santos 1132257020
    Juan Manuel Santos 58244743
    Juan Manuel Santos 2330942652
    Juan Manuel Santos 601399468
    Juan Manuel Santos 1244682984
    Juan Manuel Santos 100997690
    Juan Manuel Santos 38630618
    Juan Manuel Santos 1707574693
    Juan Manuel Santos 3146111158
    Juan Manuel Santos 154021500
    Juan Manuel Santos 106537212
    Juan Manuel Santos 275249836
    Juan Manuel Santos 90617595
    Juan Manuel Santos 216134937
    Juan Manuel Santos 202812622
    Juan Manuel Santos 59258459
    Juan Manuel Santos 626542351
    Juan Manuel Santos 155428489
    Juan Manuel Santos 1190937378
    Juan Manuel Santos 169807662
    Juan Manuel Santos 736101649
    Juan Manuel Santos 47855400
    Juan Manuel Santos 963114199
    Juan Manuel Santos 896828255373848576
    Juan Manuel Santos 627541001
    Juan Manuel Santos 63171279
    Juan Manuel Santos 867140092686741504
    Juan Manuel Santos 2499219806
    Juan Manuel Santos 1976143068
    Juan Manuel Santos 543717453
    Juan Manuel Santos 528775642
    Juan Manuel Santos 913131817
    Juan Manuel Santos 186468775
    Juan Manuel Santos 106464020
    Juan Manuel Santos 252784520
    Juan Manuel Santos 745275923746988032
    Juan Manuel Santos 2922953385
    Juan Manuel Santos 1395199711
    Juan Manuel Santos 21346619
    Juan Manuel Santos 23482357
    Juan Manuel Santos 219028402
    Juan Manuel Santos 712368508340969472
    Juan Manuel Santos 427802004
    Juan Manuel Santos 1089295801
    Juan Manuel Santos 429363031
    Juan Manuel Santos 1485419634
    Juan Manuel Santos 592869404
    Juan Manuel Santos 189154821
    Juan Manuel Santos 120176950
    Juan Manuel Santos 822215679726100480
    Juan Manuel Santos 4439886208
    Juan Manuel Santos 1397629518
    Juan Manuel Santos 136001458
    Juan Manuel Santos 77100348
    Juan Manuel Santos 325851006
    Juan Manuel Santos 612791811
    Juan Manuel Santos 460163041
    Juan Manuel Santos 159162810
    Juan Manuel Santos 2674249872
    Juan Manuel Santos 810644283338424320
    Juan Manuel Santos 203192213
    Juan Manuel Santos 1406489658
    Juan Manuel Santos 1172259948
    Juan Manuel Santos 118472243
    Juan Manuel Santos 3247090162
    Juan Manuel Santos 3203085982
    Juan Manuel Santos 1479902804
    Juan Manuel Santos 43989547
    Juan Manuel Santos 785657408
    Juan Manuel Santos 955886420
    Juan Manuel Santos 712840953
    Juan Manuel Santos 569573098
    Juan Manuel Santos 3134768224
    Juan Manuel Santos 272198144
    Juan Manuel Santos 46485425
    Juan Manuel Santos 498931152
    Juan Manuel Santos 280755772
    Juan Manuel Santos 756601913437724672
    Juan Manuel Santos 97581739
    Juan Manuel Santos 67693913
    Juan Manuel Santos 716001255852740608
    Juan Manuel Santos 151040450
    Juan Manuel Santos 61018481
    Juan Manuel Santos 82500286
    Juan Manuel Santos 14340875
    Juan Manuel Santos 39219035
    Juan Manuel Santos 16432083
    Juan Manuel Santos 28101138
    Juan Manuel Santos 747891746512736256
    Juan Manuel Santos 59579941
    Juan Manuel Santos 3401638840
    Juan Manuel Santos 343746505
    Juan Manuel Santos 242448965
    Juan Manuel Santos 229966028
    Juan Manuel Santos 256186607
    Juan Manuel Santos 2720301821
    Juan Manuel Santos 768533872564895744
    Juan Manuel Santos 91103479
    Juan Manuel Santos 53579275
    Juan Manuel Santos 2243210644
    Juan Manuel Santos 2224105939
    Juan Manuel Santos 615706086
    Juan Manuel Santos 54020546
    Juan Manuel Santos 1861062565
    Juan Manuel Santos 1277763643
    Juan Manuel Santos 252212000
    Juan Manuel Santos 516618669
    Juan Manuel Santos 1324343046
    Juan Manuel Santos 572688632
    Juan Manuel Santos 208019751
    Juan Manuel Santos 145903908
    Juan Manuel Santos 296486839
    Juan Manuel Santos 4119914644
    Juan Manuel Santos 7713202
    Juan Manuel Santos 216457140
    Juan Manuel Santos 966113328
    Juan Manuel Santos 260327025
    Juan Manuel Santos 719865696184877058
    Juan Manuel Santos 4923782098
    Juan Manuel Santos 1074952813
    Juan Manuel Santos 2207414027
    Juan Manuel Santos 1126594650
    Juan Manuel Santos 3387719848
    Juan Manuel Santos 133405881
    Juan Manuel Santos 2364383323
    Juan Manuel Santos 2327688362
    Juan Manuel Santos 743881276504031234
    Juan Manuel Santos 3387638997
    Juan Manuel Santos 20451381
    Juan Manuel Santos 302794483
    Juan Manuel Santos 3905076374
    Juan Manuel Santos 1729302205
    Juan Manuel Santos 722275713408229376
    Juan Manuel Santos 388618424
    Juan Manuel Santos 84365525
    Juan Manuel Santos 52958439
    Juan Manuel Santos 133597997
    Juan Manuel Santos 818876014390603776
    Juan Manuel Santos 1093090866
    Juan Manuel Santos 185859540
    Juan Manuel Santos 184590625
    Juan Manuel Santos 275145560
    Juan Manuel Santos 110476495
    Juan Manuel Santos 704263276625002496
    Juan Manuel Santos 704009266047361026
    Juan Manuel Santos 242836537
    Juan Manuel Santos 4439016015
    Juan Manuel Santos 74936691
    Juan Manuel Santos 174361486
    Juan Manuel Santos 1199008584
    Juan Manuel Santos 3239192692
    Juan Manuel Santos 766210752
    Juan Manuel Santos 204876189
    Juan Manuel Santos 2178900853
    Juan Manuel Santos 298163347
    Juan Manuel Santos 116763916
    Juan Manuel Santos 77047295
    Juan Manuel Santos 2713176725
    Juan Manuel Santos 164372277
    Juan Manuel Santos 3374091909
    Juan Manuel Santos 2617471956
    Juan Manuel Santos 144509738
    Juan Manuel Santos 1897857392
    Juan Manuel Santos 745646359
    Juan Manuel Santos 468794446
    Juan Manuel Santos 97452391
    Juan Manuel Santos 37341338
    Juan Manuel Santos 62945553
    Juan Manuel Santos 305876654
    Juan Manuel Santos 66711542
    Juan Manuel Santos 121537176
    Juan Manuel Santos 3003783496
    Juan Manuel Santos 138092168
    Juan Manuel Santos 2370838338
    Juan Manuel Santos 2802545808
    Juan Manuel Santos 106610881
    Juan Manuel Santos 7996082
    Juan Manuel Santos 14436030
    Juan Manuel Santos 19923515
    Juan Manuel Santos 105082141
    Juan Manuel Santos 10012122
    Juan Manuel Santos 373490841
    Juan Manuel Santos 150270167
    Juan Manuel Santos 1389635282
    Juan Manuel Santos 293612779
    Juan Manuel Santos 3075095423
    Juan Manuel Santos 2939615002
    Juan Manuel Santos 139426586
    Juan Manuel Santos 142640400
    Juan Manuel Santos 709179208
    Juan Manuel Santos 238210589
    Juan Manuel Santos 69563216
    Juan Manuel Santos 150664860
    Juan Manuel Santos 87713796
    Juan Manuel Santos 92297241
    Juan Manuel Santos 187059094
    Juan Manuel Santos 128780871
    Juan Manuel Santos 70385068
    Juan Manuel Santos 67676157
    Juan Manuel Santos 281217900
    Juan Manuel Santos 22386555
    Juan Manuel Santos 337783129
    Juan Manuel Santos 814267892
    Juan Manuel Santos 15718680
    Juan Manuel Santos 111188115
    Juan Manuel Santos 26060210
    Juan Manuel Santos 137775270
    Juan Manuel Santos 163527191
    Juan Manuel Santos 280285987
    Juan Manuel Santos 987723554
    Juan Manuel Santos 102700680
    Juan Manuel Santos 126832572
    Juan Manuel Santos 1483758774
    Juan Manuel Santos 1275304002
    Juan Manuel Santos 2535526602
    Juan Manuel Santos 109903280
    Juan Manuel Santos 165748292
    Juan Manuel Santos 433564921
    Juan Manuel Santos 1550842056
    Juan Manuel Santos 61034178
    Juan Manuel Santos 2319302557
    Juan Manuel Santos 36276135
    Juan Manuel Santos 149904423
    Juan Manuel Santos 278880622
    Juan Manuel Santos 1959730339
    Juan Manuel Santos 2186750090
    Juan Manuel Santos 1959674058
    Juan Manuel Santos 2187869857
    Juan Manuel Santos 1959751327
    Juan Manuel Santos 2184829730
    Juan Manuel Santos 143684254
    Juan Manuel Santos 49411494
    Juan Manuel Santos 68571141
    Juan Manuel Santos 155123018
    Juan Manuel Santos 41017936
    Juan Manuel Santos 2392831410
    Juan Manuel Santos 149572135
    Juan Manuel Santos 149178822
    Juan Manuel Santos 2184520274
    Juan Manuel Santos 188900185
    Juan Manuel Santos 216446082
    Juan Manuel Santos 83233882
    Juan Manuel Santos 268900159
    Juan Manuel Santos 1729043670
    Juan Manuel Santos 2282287610
    Juan Manuel Santos 2282550270
    Juan Manuel Santos 1917979580
    Juan Manuel Santos 2282508205
    Juan Manuel Santos 261915091
    Juan Manuel Santos 2291721956
    Juan Manuel Santos 768087594
    Juan Manuel Santos 59983134
    Juan Manuel Santos 2293307539
    Juan Manuel Santos 759181446
    Juan Manuel Santos 92162698
    Juan Manuel Santos 163961519
    Juan Manuel Santos 2398336104
    Juan Manuel Santos 80936145
    Juan Manuel Santos 1493709114
    Juan Manuel Santos 50139422
    Juan Manuel Santos 254115362
    Juan Manuel Santos 254176678
    Juan Manuel Santos 319807570
    Juan Manuel Santos 202475762
    Juan Manuel Santos 1497241225
    Juan Manuel Santos 1471068170
    Juan Manuel Santos 1026844724
    Juan Manuel Santos 1238774719
    Juan Manuel Santos 1400102737
    Juan Manuel Santos 87266285
    Juan Manuel Santos 1572425550
    Juan Manuel Santos 274574679
    Juan Manuel Santos 128342805
    Juan Manuel Santos 135321834
    Juan Manuel Santos 195905174
    Juan Manuel Santos 100583387
    Juan Manuel Santos 1324417764
    Juan Manuel Santos 5520952
    Juan Manuel Santos 174492304
    Juan Manuel Santos 158883467
    Juan Manuel Santos 79908188
    Juan Manuel Santos 23325469
    Juan Manuel Santos 18847632
    Juan Manuel Santos 25073877
    Juan Manuel Santos 17266725
    Juan Manuel Santos 133702633
    Juan Manuel Santos 38871237
    Juan Manuel Santos 40663284
    Juan Manuel Santos 39203045
    Juan Manuel Santos 114469124
    Juan Manuel Santos 264880868
    Juan Manuel Santos 30919385
    Juan Manuel Santos 60093623
    Juan Manuel Santos 191955247
    Juan Manuel Santos 118906931
    Juan Manuel Santos 15222678
    Juan Manuel Santos 2292016862
    Juan Manuel Santos 274087824
    Juan Manuel Santos 34934634
    Juan Manuel Santos 155062488
    Juan Manuel Santos 132961448
    Juan Manuel Santos 71876190
    Juan Manuel Santos 23375688
    Juan Manuel Santos 25341996
    Juan Manuel Santos 2425151
    Juan Manuel Santos 15846407
    Juan Manuel Santos 200163448
    Juan Manuel Santos 20255162
    Juan Manuel Santos 15687962
    Juan Manuel Santos 65289126
    Juan Manuel Santos 243284052
    Juan Manuel Santos 20139902
    Juan Manuel Santos 79293791
    Juan Manuel Santos 133093395
    Juan Manuel Santos 19058681
    Juan Manuel Santos 19554706
    Juan Manuel Santos 816653
    Juan Manuel Santos 24807616
    Juan Manuel Santos 13058772
    Juan Manuel Santos 18667907
    Juan Manuel Santos 16000318
    Juan Manuel Santos 31239408
    Juan Manuel Santos 9695312
    Juan Manuel Santos 32745368
    Juan Manuel Santos 9866582
    Juan Manuel Santos 59247894
    Juan Manuel Santos 56505125
    Juan Manuel Santos 141666777
    Juan Manuel Santos 35474809
    Juan Manuel Santos 52551600
    Juan Manuel Santos 6107422
    Juan Manuel Santos 34655603
    Juan Manuel Santos 13565472
    Juan Manuel Santos 203162990
    Juan Manuel Santos 14335880
    Juan Manuel Santos 349859290
    Juan Manuel Santos 14700117
    Juan Manuel Santos 36047098
    Juan Manuel Santos 1636590253
    Juan Manuel Santos 16311797
    Juan Manuel Santos 18646108
    Juan Manuel Santos 27311044
    Juan Manuel Santos 1432977446
    Juan Manuel Santos 57963724
    Juan Manuel Santos 90484508
    Juan Manuel Santos 1347285918
    Juan Manuel Santos 216881337
    Juan Manuel Santos 153474021
    Juan Manuel Santos 16679529
    Juan Manuel Santos 44196397
    Juan Manuel Santos 595515713
    Juan Manuel Santos 1049382967
    Juan Manuel Santos 631215183
    Juan Manuel Santos 15447156
    Juan Manuel Santos 182075295
    Juan Manuel Santos 221431892
    Juan Manuel Santos 117573638
    Juan Manuel Santos 718591393
    Juan Manuel Santos 802614236
    Juan Manuel Santos 576398505
    Juan Manuel Santos 188406736
    Juan Manuel Santos 425489366
    Juan Manuel Santos 226746906
    Juan Manuel Santos 199594374
    Juan Manuel Santos 281616678
    Juan Manuel Santos 204736708
    Juan Manuel Santos 56562949
    Juan Manuel Santos 759694268
    Juan Manuel Santos 221136875
    Juan Manuel Santos 275577475
    Juan Manuel Santos 1193595097
    Juan Manuel Santos 184049255
    Juan Manuel Santos 494156101
    Juan Manuel Santos 351710623
    Juan Manuel Santos 365520462
    Juan Manuel Santos 1321064839
    Juan Manuel Santos 217468413
    Juan Manuel Santos 236624354
    Juan Manuel Santos 188384056
    Juan Manuel Santos 215235619
    Juan Manuel Santos 304337483
    Juan Manuel Santos 125620036
    Juan Manuel Santos 612717405
    Juan Manuel Santos 137409698
    Juan Manuel Santos 73149774
    Juan Manuel Santos 324641017
    Juan Manuel Santos 97482906
    Juan Manuel Santos 118766970
    Juan Manuel Santos 386470165
    Juan Manuel Santos 188441706
    Juan Manuel Santos 74637454
    Juan Manuel Santos 21774544
    Juan Manuel Santos 275207198
    Juan Manuel Santos 257809119
    Juan Manuel Santos 237814456
    Juan Manuel Santos 553977396
    Juan Manuel Santos 60720632
    Juan Manuel Santos 126575175
    Juan Manuel Santos 28989171
    Juan Manuel Santos 17291379
    Juan Manuel Santos 47291507
    Juan Manuel Santos 9206682
    Juan Manuel Santos 59178785
    Juan Manuel Santos 71613889
    Juan Manuel Santos 16039608
    Juan Manuel Santos 134072225
    Juan Manuel Santos 61206678
    Juan Manuel Santos 17686758
    Juan Manuel Santos 20973716
    Juan Manuel Santos 24433144
    Juan Manuel Santos 731573
    Juan Manuel Santos 65319527
    Juan Manuel Santos 34222270
    Juan Manuel Santos 19617637
    Juan Manuel Santos 203590680
    Juan Manuel Santos 18746024
    Juan Manuel Santos 99802826
    Juan Manuel Santos 42424530
    Juan Manuel Santos 30509098
    Juan Manuel Santos 224001297
    Juan Manuel Santos 124265227
    Juan Manuel Santos 403357622
    Juan Manuel Santos 602056943
    Juan Manuel Santos 199246006
    Juan Manuel Santos 59797076
    Juan Manuel Santos 176487731
    Juan Manuel Santos 44171091
    Juan Manuel Santos 21279340
    Juan Manuel Santos 1035491
    Juan Manuel Santos 8820652
    Juan Manuel Santos 13348
    Juan Manuel Santos 17463660
    Juan Manuel Santos 5768872
    Juan Manuel Santos 8453452
    Juan Manuel Santos 10202
    Juan Manuel Santos 8596022
    Juan Manuel Santos 839321
    Juan Manuel Santos 52536992
    Juan Manuel Santos 281182832
    Juan Manuel Santos 9770772
    Juan Manuel Santos 240268656
    Juan Manuel Santos 51918727
    Juan Manuel Santos 68861723
    Juan Manuel Santos 31127446
    Juan Manuel Santos 136426609
    Juan Manuel Santos 351065668
    Juan Manuel Santos 113120733
    Juan Manuel Santos 450200372
    Juan Manuel Santos 32995666
    Juan Manuel Santos 40974469
    Juan Manuel Santos 17004618
    Juan Manuel Santos 451586190
    Juan Manuel Santos 551970102
    Juan Manuel Santos 241252324
    Juan Manuel Santos 14434063
    Juan Manuel Santos 59459771
    Juan Manuel Santos 232235048
    Juan Manuel Santos 558644290
    Juan Manuel Santos 19608273
    Juan Manuel Santos 59145948
    Juan Manuel Santos 243680902
    Juan Manuel Santos 418991973
    Juan Manuel Santos 45013575
    Juan Manuel Santos 431282090
    Juan Manuel Santos 1615463502
    Juan Manuel Santos 74776409
    Juan Manuel Santos 483767812
    Juan Manuel Santos 57156283
    Juan Manuel Santos 1228312916
    Juan Manuel Santos 1623730970
    Juan Manuel Santos 2214190268
    Juan Manuel Santos 263780425
    Juan Manuel Santos 38650624
    Juan Manuel Santos 2202387091
    Juan Manuel Santos 57090216
    Juan Manuel Santos 45360953
    Juan Manuel Santos 32355144
    Juan Manuel Santos 158313996
    Juan Manuel Santos 39313353
    Juan Manuel Santos 248760009
    Juan Manuel Santos 2249203393
    Juan Manuel Santos 305141546
    Juan Manuel Santos 2177040541
    Juan Manuel Santos 40463380
    Juan Manuel Santos 111123176
    Juan Manuel Santos 211716251
    Juan Manuel Santos 2239842114
    Juan Manuel Santos 17179368
    Juan Manuel Santos 153487069
    Juan Manuel Santos 18170896
    Juan Manuel Santos 167842113
    Juan Manuel Santos 46527223
    Juan Manuel Santos 143094610
    Juan Manuel Santos 1901546563
    Juan Manuel Santos 111630645
    Juan Manuel Santos 8315692
    Juan Manuel Santos 1532061
    Juan Manuel Santos 18358699
    Juan Manuel Santos 747659868
    Juan Manuel Santos 972775298
    Juan Manuel Santos 117873666
    Juan Manuel Santos 771645044
    Juan Manuel Santos 403909017
    Juan Manuel Santos 263717250
    Juan Manuel Santos 621836839
    Juan Manuel Santos 208710318
    Juan Manuel Santos 320350378
    Juan Manuel Santos 175192117
    Juan Manuel Santos 313088307
    Juan Manuel Santos 225363445
    Juan Manuel Santos 66814930
    Juan Manuel Santos 36589869
    Juan Manuel Santos 116000096
    Juan Manuel Santos 177019825
    Juan Manuel Santos 174424672
    Juan Manuel Santos 69333029
    Juan Manuel Santos 234053160
    Juan Manuel Santos 119979022
    Juan Manuel Santos 254274083
    Juan Manuel Santos 104974333
    Juan Manuel Santos 106876550
    Juan Manuel Santos 18868617
    Juan Manuel Santos 87808186
    Juan Manuel Santos 74882899
    Juan Manuel Santos 26540417
    Juan Manuel Santos 105491152
    Juan Manuel Santos 36307418
    Juan Manuel Santos 16576356
    Juan Manuel Santos 267110606
    Juan Manuel Santos 16148149
    Juan Manuel Santos 48439715
    Juan Manuel Santos 8229382
    Juan Manuel Santos 187647136
    Juan Manuel Santos 156779155
    Juan Manuel Santos 160705841
    Juan Manuel Santos 222063930
    Juan Manuel Santos 154284860
    Juan Manuel Santos 100615235
    Juan Manuel Santos 71959945
    Juan Manuel Santos 179137892
    Juan Manuel Santos 112140330
    Juan Manuel Santos 88959830
    Juan Manuel Santos 195182193
    Juan Manuel Santos 121346409
    Juan Manuel Santos 257276028
    Juan Manuel Santos 160918650
    Juan Manuel Santos 161280980
    Juan Manuel Santos 154000683
    Juan Manuel Santos 105219689
    Juan Manuel Santos 50216232
    Juan Manuel Santos 274624752
    Juan Manuel Santos 62195042
    Juan Manuel Santos 151582578
    Juan Manuel Santos 165590781
    Juan Manuel Santos 213485813
    Juan Manuel Santos 180675805
    Juan Manuel Santos 165590284
    Juan Manuel Santos 111009302
    Juan Manuel Santos 152462745
    Juan Manuel Santos 98886687
    Juan Manuel Santos 208852175
    Juan Manuel Santos 192414095
    Juan Manuel Santos 274684996
    Juan Manuel Santos 315834587
    Juan Manuel Santos 29846969
    Juan Manuel Santos 244613813
    Juan Manuel Santos 105635005
    Juan Manuel Santos 399936421
    Juan Manuel Santos 122145627
    Juan Manuel Santos 245988284
    Juan Manuel Santos 541909201
    Juan Manuel Santos 315618522
    Juan Manuel Santos 404129645
    Juan Manuel Santos 1245431323
    Juan Manuel Santos 281790356
    Juan Manuel Santos 53557991
    Juan Manuel Santos 35793443
    Juan Manuel Santos 130970538
    Juan Manuel Santos 115246274
    Juan Manuel Santos 23978731
    Juan Manuel Santos 16847337
    Juan Manuel Santos 123001743
    Juan Manuel Santos 56558664
    Juan Manuel Santos 67096372
    Juan Manuel Santos 90159082
    Juan Manuel Santos 117921371
    Juan Manuel Santos 87862620
    Juan Manuel Santos 46695675
    Juan Manuel Santos 39165786
    Juan Manuel Santos 62561348
    Juan Manuel Santos 167447816
    Juan Manuel Santos 50944898
    Juan Manuel Santos 53223256
    Juan Manuel Santos 141026344
    Juan Manuel Santos 138277823
    Juan Manuel Santos 89472472
    Juan Manuel Santos 84626761
    Juan Manuel Santos 453955367
    Juan Manuel Santos 45383275
    Juan Manuel Santos 38008997
    Juan Manuel Santos 124242278
    Juan Manuel Santos 56448180
    Juan Manuel Santos 117843789
    Juan Manuel Santos 95684520
    Juan Manuel Santos 116935068
    Juan Manuel Santos 18441350
    Juan Manuel Santos 57002908
    Juan Manuel Santos 15695712
    Juan Manuel Santos 46831967
    Juan Manuel Santos 82097571
    Juan Manuel Santos 18021445
    Juan Manuel Santos 253582640
    Juan Manuel Santos 127555008
    Juan Manuel Santos 2304544405
    Juan Manuel Santos 7586362
    Juan Manuel Santos 13706042
    Juan Manuel Santos 322904764
    Juan Manuel Santos 14985228
    Juan Manuel Santos 380
    Juan Manuel Santos 14380175
    Juan Manuel Santos 27471945
    Juan Manuel Santos 173955238
    Juan Manuel Santos 312069087
    Juan Manuel Santos 378223565
    Juan Manuel Santos 23217821
    Juan Manuel Santos 9207632
    Juan Manuel Santos 36600339
    Juan Manuel Santos 415859364
    Juan Manuel Santos 234489403
    Juan Manuel Santos 475757358
    Juan Manuel Santos 462272171
    Juan Manuel Santos 20917630
    Juan Manuel Santos 22193381
    Juan Manuel Santos 18586800
    Juan Manuel Santos 657863
    Juan Manuel Santos 14600116
    Juan Manuel Santos 5841
    Juan Manuel Santos 7647882
    Juan Manuel Santos 35404273
    Juan Manuel Santos 210967384
    Juan Manuel Santos 22265745
    Juan Manuel Santos 602317143
    Juan Manuel Santos 50033539
    Juan Manuel Santos 431412404
    Juan Manuel Santos 61996549
    Juan Manuel Santos 203718372
    Juan Manuel Santos 93465778
    Juan Manuel Santos 1032290077
    Juan Manuel Santos 816321
    Juan Manuel Santos 40348978
    Juan Manuel Santos 522205169
    Juan Manuel Santos 232739652
    Juan Manuel Santos 259701844
    Juan Manuel Santos 9464422
    Juan Manuel Santos 333081796
    Juan Manuel Santos 68167893
    Juan Manuel Santos 13226712
    Juan Manuel Santos 118203
    Juan Manuel Santos 226933619
    Juan Manuel Santos 2335526227
    Juan Manuel Santos 13
    Juan Manuel Santos 1364930179
    Juan Manuel Santos 52668867
    Juan Manuel Santos 16581604
    Juan Manuel Santos 119064111
    Juan Manuel Santos 1033712750
    Juan Manuel Santos 111398372
    Juan Manuel Santos 86242525
    Juan Manuel Santos 59855362
    Juan Manuel Santos 67788043
    Juan Manuel Santos 8161232
    Juan Manuel Santos 291
    Juan Manuel Santos 56502954
    Juan Manuel Santos 19849482
    Juan Manuel Santos 127470921
    Juan Manuel Santos 82643112
    Juan Manuel Santos 15012352
    Juan Manuel Santos 104861330
    Juan Manuel Santos 102728288
    Juan Manuel Santos 58930222
    Juan Manuel Santos 77625278
    Juan Manuel Santos 15918708
    Juan Manuel Santos 12044602
    Juan Manuel Santos 18460199
    Juan Manuel Santos 117109734
    Juan Manuel Santos 154294030
    Juan Manuel Santos 1606228135
    Juan Manuel Santos 2307823174
    Juan Manuel Santos 262349588
    Juan Manuel Santos 138135627
    Juan Manuel Santos 2165556090
    Juan Manuel Santos 1923807019
    Juan Manuel Santos 1335592814
    Juan Manuel Santos 983636101
    Juan Manuel Santos 379072195
    Juan Manuel Santos 374607558
    Juan Manuel Santos 43146039
    Juan Manuel Santos 117808323
    Juan Manuel Santos 52693558
    Juan Manuel Santos 48336213
    Juan Manuel Santos 20642645
    Juan Manuel Santos 256822889
    Juan Manuel Santos 15647676
    Juan Manuel Santos 59157393
    Juan Manuel Santos 48778278
    Juan Manuel Santos 80102969
    Juan Manuel Santos 69231483
    Juan Manuel Santos 347420129
    Juan Manuel Santos 115600215
    Juan Manuel Santos 16689804
    Juan Manuel Santos 62154340
    Juan Manuel Santos 170714191
    Juan Manuel Santos 511012931
    Juan Manuel Santos 1330457336
    Juan Manuel Santos 144927419
    Juan Manuel Santos 64083835
    Juan Manuel Santos 11194332
    Juan Manuel Santos 16482694
    Juan Manuel Santos 205011496
    Juan Manuel Santos 139092348
    Juan Manuel Santos 143835534
    Juan Manuel Santos 125749584
    Juan Manuel Santos 19224439
    Juan Manuel Santos 304909941
    Juan Manuel Santos 44706837
    Juan Manuel Santos 592878988
    Juan Manuel Santos 272019676
    Juan Manuel Santos 17469492
    Juan Manuel Santos 17965523
    Juan Manuel Santos 19784906
    Juan Manuel Santos 260894276
    Juan Manuel Santos 237286607
    Juan Manuel Santos 468669588
    Juan Manuel Santos 214206926
    Juan Manuel Santos 127968593
    Juan Manuel Santos 32648476
    Juan Manuel Santos 261228758
    Juan Manuel Santos 37710752
    Juan Manuel Santos 305835391
    Juan Manuel Santos 115522779
    Juan Manuel Santos 201733703
    Juan Manuel Santos 273460252
    Juan Manuel Santos 185349940
    Juan Manuel Santos 214208015
    Juan Manuel Santos 1014384037
    Juan Manuel Santos 52536879
    Juan Manuel Santos 37813432
    Juan Manuel Santos 39537848
    Juan Manuel Santos 373471064
    Juan Manuel Santos 82652901
    Juan Manuel Santos 15648827
    Juan Manuel Santos 36928426
    Juan Manuel Santos 30412016
    Juan Manuel Santos 89303321
    Juan Manuel Santos 79327591
    Juan Manuel Santos 154605679
    Juan Manuel Santos 150490233
    Juan Manuel Santos 14882900
    Juan Manuel Santos 25093616
    Juan Manuel Santos 1344359197
    Juan Manuel Santos 1046209014
    Juan Manuel Santos 340613443
    Juan Manuel Santos 757303975
    Juan Manuel Santos 220779515
    Juan Manuel Santos 15764644
    Juan Manuel Santos 818910970567344128
    Juan Manuel Santos 325830217
    Juan Manuel Santos 818927131883356161
    Juan Manuel Santos 113420831
    Juan Manuel Santos 14159148
    Juan Manuel Santos 16153562
    Juan Manuel Santos 14361155
    Juan Manuel Santos 85289376
    Juan Manuel Santos 801010310
    Juan Manuel Santos 59517623
    Juan Manuel Santos 16955514
    Juan Manuel Santos 626592458
    Juan Manuel Santos 65369125
    Juan Manuel Santos 132646498
    Juan Manuel Santos 172001398
    Juan Manuel Santos 2335793935
    Juan Manuel Santos 82545357
    Juan Manuel Santos 61595443
    Juan Manuel Santos 44039298
    Juan Manuel Santos 26585095
    Juan Manuel Santos 19792505
    Juan Manuel Santos 213539643
    Juan Manuel Santos 372862013
    Juan Manuel Santos 444864072
    Juan Manuel Santos 803262500
    Juan Manuel Santos 26640415
    Juan Manuel Santos 213061783
    Juan Manuel Santos 285366215
    Juan Manuel Santos 236611093
    Juan Manuel Santos 161801527
    Juan Manuel Santos 584950438
    Juan Manuel Santos 238546222
    Juan Manuel Santos 54421652
    Juan Manuel Santos 364947550
    Juan Manuel Santos 120153772
    Juan Manuel Santos 15865878
    Juan Manuel Santos 18175018
    Juan Manuel Santos 21000110
    Juan Manuel Santos 20427406
    Juan Manuel Santos 19429847
    Juan Manuel Santos 5694822
    Juan Manuel Santos 50393960
    Juan Manuel Santos 48289662
    Juan Manuel Santos 5695032
    Juan Manuel Santos 174801117
    Juan Manuel Santos 131144285
    Juan Manuel Santos 5120691
    Juan Manuel Santos 47802574
    Juan Manuel Santos 341916211
    Juan Manuel Santos 466394466
    Juan Manuel Santos 160864441
    Juan Manuel Santos 109387470
    Juan Manuel Santos 126672013
    Juan Manuel Santos 84816227
    Juan Manuel Santos 487977202
    Juan Manuel Santos 133880286
    Juan Manuel Santos 132971039
    Juan Manuel Santos 103171573
    Juan Manuel Santos 231577324
    Juan Manuel Santos 1626545264
    Juan Manuel Santos 74515095
    Juan Manuel Santos 214154280
    Juan Manuel Santos 325325210
    Juan Manuel Santos 42434332
    Juan Manuel Santos 102482331
    Juan Manuel Santos 71629877
    Juan Manuel Santos 27011708
    Juan Manuel Santos 27860681
    Juan Manuel Santos 15460048
    Juan Manuel Santos 39585367
    Juan Manuel Santos 176932593
    Juan Manuel Santos 500214583
    Juan Manuel Santos 845599117
    Juan Manuel Santos 240389001
    Juan Manuel Santos 596561940
    Juan Manuel Santos 86691471
    Juan Manuel Santos 16589206
    Juan Manuel Santos 278809613
    Juan Manuel Santos 456038098
    Juan Manuel Santos 15588657
    Juan Manuel Santos 40744725
    Juan Manuel Santos 215439713
    Juan Manuel Santos 15492359
    Juan Manuel Santos 21114659
    Juan Manuel Santos 1450133648
    Juan Manuel Santos 121817564
    Juan Manuel Santos 114873372
    Juan Manuel Santos 14342564
    Juan Manuel Santos 80711467
    Juan Manuel Santos 86855181
    Juan Manuel Santos 87781992
    Juan Manuel Santos 50562028
    Juan Manuel Santos 59387254
    Juan Manuel Santos 106744214
    Juan Manuel Santos 61890276
    Juan Manuel Santos 63164952
    Juan Manuel Santos 36394208
    Juan Manuel Santos 15346918
    Juan Manuel Santos 31892440
    Juan Manuel Santos 136243285
    Juan Manuel Santos 73181712
    Juan Manuel Santos 33998183
    Juan Manuel Santos 28486855
    Juan Manuel Santos 129834397
    Juan Manuel Santos 16935292
    Juan Manuel Santos 24770812
    Juan Manuel Santos 17822514
    Juan Manuel Santos 14606079
    Juan Manuel Santos 726576589
    Juan Manuel Santos 18731529
    Juan Manuel Santos 76348185
    Juan Manuel Santos 27735210
    Juan Manuel Santos 26312335
    Juan Manuel Santos 55379094
    Juan Manuel Santos 50675591
    Juan Manuel Santos 266871603
    Juan Manuel Santos 153183984
    Juan Manuel Santos 129713764
    Juan Manuel Santos 39621575
    Juan Manuel Santos 161951759
    Juan Manuel Santos 95416366
    Juan Manuel Santos 262892038
    Juan Manuel Santos 443455853
    Juan Manuel Santos 299715442
    Juan Manuel Santos 190264901
    Juan Manuel Santos 146340387
    Juan Manuel Santos 76508157
    Juan Manuel Santos 349780099
    Juan Manuel Santos 6342542
    Juan Manuel Santos 141009407
    Juan Manuel Santos 603974189
    Juan Manuel Santos 101507962
    Juan Manuel Santos 135252488
    Juan Manuel Santos 52745910
    

    Rate limit reached. Sleeping for: 687
    

    Juan Manuel Santos 515682264
    Juan Manuel Santos 259930770
    Juan Manuel Santos 347465945
    Juan Manuel Santos 345879289
    Juan Manuel Santos 189701242
    Juan Manuel Santos 372371190
    Juan Manuel Santos 43462317
    Juan Manuel Santos 527483189
    Juan Manuel Santos 93878848
    Juan Manuel Santos 52074209
    Juan Manuel Santos 45106278
    Juan Manuel Santos 69516296
    Juan Manuel Santos 14113935
    Juan Manuel Santos 14071276
    Juan Manuel Santos 308257399
    Juan Manuel Santos 590702211
    Juan Manuel Santos 309036318
    Juan Manuel Santos 74964230
    Juan Manuel Santos 23793797
    Juan Manuel Santos 115705156
    Juan Manuel Santos 389116776
    Juan Manuel Santos 142035151
    Juan Manuel Santos 227317182
    Juan Manuel Santos 124492052
    Juan Manuel Santos 105931327
    Juan Manuel Santos 63478213
    Juan Manuel Santos 961161565
    Juan Manuel Santos 54328320
    Juan Manuel Santos 766137212
    Juan Manuel Santos 1464692276
    Juan Manuel Santos 114793020
    Juan Manuel Santos 1263426764
    Juan Manuel Santos 164836097
    Juan Manuel Santos 785239554
    Juan Manuel Santos 155334155
    Juan Manuel Santos 36683668
    Juan Manuel Santos 81163402
    Juan Manuel Santos 187042474
    Juan Manuel Santos 19390244
    Juan Manuel Santos 192920728
    Juan Manuel Santos 31277095
    Juan Manuel Santos 116548171
    Juan Manuel Santos 161318577
    Juan Manuel Santos 612415067
    Juan Manuel Santos 364383398
    Juan Manuel Santos 721428470
    Juan Manuel Santos 38810966
    Juan Manuel Santos 24046313
    Juan Manuel Santos 321860938
    Juan Manuel Santos 180479756
    Juan Manuel Santos 38751529
    Juan Manuel Santos 14677919
    Juan Manuel Santos 190229245
    Juan Manuel Santos 1963312058
    Juan Manuel Santos 22081607
    Juan Manuel Santos 16465385
    Juan Manuel Santos 423658264
    Juan Manuel Santos 26764002
    Juan Manuel Santos 44044835
    Juan Manuel Santos 10117892
    Juan Manuel Santos 14412844
    Juan Manuel Santos 131500972
    Juan Manuel Santos 1947301
    Juan Manuel Santos 9300262
    Juan Manuel Santos 259403751
    Juan Manuel Santos 5988062
    Juan Manuel Santos 410605574
    Juan Manuel Santos 14293310
    Juan Manuel Santos 22001973
    Juan Manuel Santos 4898091
    Juan Manuel Santos 18949452
    Juan Manuel Santos 807095
    Juan Manuel Santos 7587032
    Juan Manuel Santos 612473
    Juan Manuel Santos 34713362
    Juan Manuel Santos 742143
    Juan Manuel Santos 14173315
    Juan Manuel Santos 16664681
    Juan Manuel Santos 111933542
    Juan Manuel Santos 127898886
    Juan Manuel Santos 28785486
    Juan Manuel Santos 15224867
    Juan Manuel Santos 3108351
    Juan Manuel Santos 169279319
    Juan Manuel Santos 201398373
    Juan Manuel Santos 466531652
    Juan Manuel Santos 20402945
    Juan Manuel Santos 23734018
    Juan Manuel Santos 15754281
    Juan Manuel Santos 31779156
    Juan Manuel Santos 15462819
    Juan Manuel Santos 1370927040
    Juan Manuel Santos 186602339
    Juan Manuel Santos 51241574
    Juan Manuel Santos 111691454
    Juan Manuel Santos 34641036
    Juan Manuel Santos 62108074
    Juan Manuel Santos 87286688
    Juan Manuel Santos 105597862
    Juan Manuel Santos 89485410
    Juan Manuel Santos 38302723
    Juan Manuel Santos 10257922
    Juan Manuel Santos 62328908
    Juan Manuel Santos 286495100
    Juan Manuel Santos 151627815
    Juan Manuel Santos 2097571
    Juan Manuel Santos 759251
    Juan Manuel Santos 33884545
    Juan Manuel Santos 21694413
    Juan Manuel Santos 63023205
    Juan Manuel Santos 494215811
    Juan Manuel Santos 96834141
    Juan Manuel Santos 237031941
    Juan Manuel Santos 50442705
    Juan Manuel Santos 35688644
    Juan Manuel Santos 595653152
    Juan Manuel Santos 195095431
    Juan Manuel Santos 84613584
    Juan Manuel Santos 240757505
    Juan Manuel Santos 80895006
    Juan Manuel Santos 254353546
    Juan Manuel Santos 28058878
    Juan Manuel Santos 153148677
    Juan Manuel Santos 19397785
    Juan Manuel Santos 160767992
    Juan Manuel Santos 250157926
    Juan Manuel Santos 229532257
    Juan Manuel Santos 124355265
    Juan Manuel Santos 615385712
    Juan Manuel Santos 110213431
    Juan Manuel Santos 16228398
    Juan Manuel Santos 14514804
    Juan Manuel Santos 17454086
    Juan Manuel Santos 60308942
    Juan Manuel Santos 23492901
    Juan Manuel Santos 15320887
    Juan Manuel Santos 29270179
    Juan Manuel Santos 14278978
    Juan Manuel Santos 17918705
    Juan Manuel Santos 62166184
    Juan Manuel Santos 182441611
    Juan Manuel Santos 934178858
    Juan Manuel Santos 14952077
    Juan Manuel Santos 18393773
    Juan Manuel Santos 111912589
    Juan Manuel Santos 73283784
    Juan Manuel Santos 222020662
    Juan Manuel Santos 80039675
    Juan Manuel Santos 817845968
    Juan Manuel Santos 239819612
    Juan Manuel Santos 15787430
    Juan Manuel Santos 80651703
    Juan Manuel Santos 437025531
    Juan Manuel Santos 59900378
    Juan Manuel Santos 104976980
    Juan Manuel Santos 132937730
    Juan Manuel Santos 175483420
    Juan Manuel Santos 184828053
    Juan Manuel Santos 67490991
    Juan Manuel Santos 195632388
    Juan Manuel Santos 158036133
    Juan Manuel Santos 202848061
    Juan Manuel Santos 576550600
    Juan Manuel Santos 373395647
    Juan Manuel Santos 116633016
    Juan Manuel Santos 73430542
    Juan Manuel Santos 263771972
    Juan Manuel Santos 214596276
    Juan Manuel Santos 104387365
    Juan Manuel Santos 169510088
    Juan Manuel Santos 240554963
    Juan Manuel Santos 185064321
    Juan Manuel Santos 72672049
    Juan Manuel Santos 204558941
    Juan Manuel Santos 167511835
    Juan Manuel Santos 484900586
    Juan Manuel Santos 355995000
    Juan Manuel Santos 80483216
    Juan Manuel Santos 301529052
    Juan Manuel Santos 1486647890
    Juan Manuel Santos 1600161152
    Juan Manuel Santos 93131556
    Juan Manuel Santos 121240793
    Juan Manuel Santos 50725573
    Juan Manuel Santos 26589987
    Juan Manuel Santos 1337785291
    Juan Manuel Santos 344634424
    Juan Manuel Santos 259925559
    Juan Manuel Santos 70093343
    Juan Manuel Santos 184584860
    Juan Manuel Santos 485511296
    Juan Manuel Santos 180733809
    Juan Manuel Santos 1522769346
    Juan Manuel Santos 20456427
    Juan Manuel Santos 382878254
    Juan Manuel Santos 50826280
    Juan Manuel Santos 512700138
    Juan Manuel Santos 14872237
    Juan Manuel Santos 469258343
    Juan Manuel Santos 985419943
    Juan Manuel Santos 153532178
    Juan Manuel Santos 460440037
    Juan Manuel Santos 1596095718
    Juan Manuel Santos 314250584
    Juan Manuel Santos 74293265
    Juan Manuel Santos 166549341
    Juan Manuel Santos 28641033
    Juan Manuel Santos 176728565
    Juan Manuel Santos 91390383
    Juan Manuel Santos 41396492
    Juan Manuel Santos 123284016
    Juan Manuel Santos 1152031460
    Juan Manuel Santos 21046818
    Juan Manuel Santos 368634756
    Juan Manuel Santos 62130152
    Juan Manuel Santos 208434435
    Juan Manuel Santos 257054178
    Juan Manuel Santos 50061806
    Juan Manuel Santos 410511310
    Juan Manuel Santos 69047795
    Juan Manuel Santos 360074959
    Juan Manuel Santos 236967368
    Juan Manuel Santos 111622172
    Juan Manuel Santos 54783895
    Juan Manuel Santos 104013642
    Juan Manuel Santos 336145436
    Juan Manuel Santos 218737843
    Juan Manuel Santos 14401149
    Juan Manuel Santos 108644499
    Juan Manuel Santos 290672220
    Juan Manuel Santos 58941487
    Juan Manuel Santos 55033131
    Juan Manuel Santos 60344499
    Juan Manuel Santos 45986928
    Juan Manuel Santos 61714691
    Juan Manuel Santos 43152482
    Juan Manuel Santos 40445356
    Juan Manuel Santos 59831983
    Juan Manuel Santos 146985042
    Juan Manuel Santos 95970111
    Juan Manuel Santos 142769153
    Juan Manuel Santos 75925968
    Juan Manuel Santos 14230524
    Juan Manuel Santos 82448700
    Juan Manuel Santos 73954053
    Juan Manuel Santos 258899658
    Juan Manuel Santos 207567525
    Juan Manuel Santos 256388684
    Juan Manuel Santos 84078498
    Juan Manuel Santos 561464650
    Juan Manuel Santos 134393005
    Juan Manuel Santos 44670915
    Juan Manuel Santos 174845293
    Juan Manuel Santos 364448703
    Juan Manuel Santos 19091845
    Juan Manuel Santos 17689842
    Juan Manuel Santos 207624039
    Juan Manuel Santos 277754020
    Juan Manuel Santos 67415301
    Juan Manuel Santos 573800821
    Juan Manuel Santos 191399200
    Juan Manuel Santos 126029381
    Juan Manuel Santos 68004957
    Juan Manuel Santos 77844512
    Juan Manuel Santos 168303922
    Juan Manuel Santos 32167239
    Juan Manuel Santos 75679003
    Juan Manuel Santos 54324587
    Juan Manuel Santos 69018805
    Juan Manuel Santos 53522219
    Juan Manuel Santos 89720770
    Juan Manuel Santos 139388858
    Juan Manuel Santos 35995585
    Juan Manuel Santos 92622085
    Juan Manuel Santos 175609100
    Juan Manuel Santos 128899092
    Juan Manuel Santos 123731499
    Juan Manuel Santos 248976058
    Juan Manuel Santos 139419229
    Juan Manuel Santos 86201320
    Juan Manuel Santos 54411594
    Juan Manuel Santos 186227903
    Juan Manuel Santos 50981729
    Juan Manuel Santos 173129929
    Juan Manuel Santos 33911394
    Juan Manuel Santos 96329413
    Juan Manuel Santos 196386908
    Juan Manuel Santos 219508242
    Juan Manuel Santos 195537073
    Juan Manuel Santos 188486159
    Juan Manuel Santos 70734968
    Juan Manuel Santos 31538488
    Juan Manuel Santos 52914117
    Juan Manuel Santos 74600905
    Juan Manuel Santos 329746058
    Juan Manuel Santos 22685200
    Juan Manuel Santos 366396523
    Juan Manuel Santos 390322897
    Juan Manuel Santos 1225390153
    Juan Manuel Santos 218592577
    Juan Manuel Santos 118907035
    Juan Manuel Santos 62337495
    Juan Manuel Santos 815911244
    Juan Manuel Santos 166311912
    Juan Manuel Santos 169794032
    Juan Manuel Santos 480101565
    Juan Manuel Santos 128039798
    Juan Manuel Santos 172822388
    Juan Manuel Santos 346047922
    Juan Manuel Santos 33905807
    Juan Manuel Santos 67359917
    Juan Manuel Santos 53292253
    Juan Manuel Santos 172936338
    Juan Manuel Santos 287444289
    Juan Manuel Santos 30725771
    Juan Manuel Santos 143490635
    Juan Manuel Santos 167143652
    Juan Manuel Santos 161084107
    Juan Manuel Santos 121169579
    Juan Manuel Santos 246089111
    Juan Manuel Santos 57324097
    Juan Manuel Santos 125360958
    Juan Manuel Santos 16777543
    Juan Manuel Santos 54690970
    Juan Manuel Santos 40368195
    Juan Manuel Santos 41221076
    Juan Manuel Santos 57325458
    Juan Manuel Santos 220139044
    Juan Manuel Santos 133124672
    Juan Manuel Santos 305085584
    Juan Manuel Santos 444813339
    Juan Manuel Santos 131204770
    Juan Manuel Santos 18791763
    Juan Manuel Santos 62501888
    Juan Manuel Santos 133108380
    Juan Manuel Santos 35866419
    Juan Manuel Santos 474213039
    Juan Manuel Santos 4808861
    Juan Manuel Santos 28332028
    Juan Manuel Santos 17380167
    Juan Manuel Santos 132800515
    Juan Manuel Santos 144875363
    Juan Manuel Santos 187142863
    Juan Manuel Santos 159950527
    Juan Manuel Santos 1404590618
    Juan Manuel Santos 16717501
    Juan Manuel Santos 155507136
    Juan Manuel Santos 961974776
    Juan Manuel Santos 634463033
    Juan Manuel Santos 932196612
    Juan Manuel Santos 93766096
    Juan Manuel Santos 36329597
    Juan Manuel Santos 126787836
    Juan Manuel Santos 1397477076
    Juan Manuel Santos 856010760
    Juan Manuel Santos 29466039
    Juan Manuel Santos 173929268
    Juan Manuel Santos 15010349
    Juan Manuel Santos 107359225
    Juan Manuel Santos 376819013
    Juan Manuel Santos 24150634
    Juan Manuel Santos 389486048
    Juan Manuel Santos 141084952
    Juan Manuel Santos 268357486
    Juan Manuel Santos 196994616
    Juan Manuel Santos 17839398
    Juan Manuel Santos 1219865652
    Juan Manuel Santos 65493023
    Juan Manuel Santos 214821759
    Juan Manuel Santos 15007149
    Juan Manuel Santos 1339835893
    Juan Manuel Santos 17220934
    Juan Manuel Santos 147362917
    Juan Manuel Santos 118544815
    Juan Manuel Santos 2298697429
    Juan Manuel Santos 2289933740
    Juan Manuel Santos 191963804
    Juan Manuel Santos 322408966
    Juan Manuel Santos 2282609288
    Juan Manuel Santos 67311138
    Juan Manuel Santos 60161414
    Juan Manuel Santos 631580827
    Juan Manuel Santos 84382121
    Juan Manuel Santos 1855367412
    Juan Manuel Santos 624023391
    Juan Manuel Santos 31535312
    Juan Manuel Santos 137146842
    Juan Manuel Santos 163986428
    Juan Manuel Santos 29202899
    Juan Manuel Santos 906765860
    Juan Manuel Santos 137908875
    Juan Manuel Santos 1267204351
    Juan Manuel Santos 1301761278
    Juan Manuel Santos 388555493
    Juan Manuel Santos 490126636
    Juan Manuel Santos 277096408
    Juan Manuel Santos 753928843
    Juan Manuel Santos 15895464
    Juan Manuel Santos 14281853
    Juan Manuel Santos 1669631264
    Juan Manuel Santos 766895953
    Juan Manuel Santos 291220589
    Juan Manuel Santos 168318256
    Juan Manuel Santos 18549724
    Juan Manuel Santos 183165874
    Juan Manuel Santos 412940784
    Juan Manuel Santos 134732045
    Juan Manuel Santos 250265046
    Juan Manuel Santos 103065157
    Juan Manuel Santos 7401202
    Juan Manuel Santos 42102939
    Juan Manuel Santos 36042554
    Juan Manuel Santos 18814998
    Juan Manuel Santos 471741741
    Juan Manuel Santos 39630199
    Juan Manuel Santos 34666670
    Juan Manuel Santos 633794939
    Juan Manuel Santos 205622130
    Juan Manuel Santos 1252764865
    Juan Manuel Santos 272613386
    Juan Manuel Santos 69209858
    Juan Manuel Santos 16389180
    Juan Manuel Santos 131574396
    Juan Manuel Santos 44335525
    Juan Manuel Santos 2897441
    Juan Manuel Santos 138814032
    Juan Manuel Santos 14224719
    Juan Manuel Santos 153810519
    Juan Manuel Santos 1307120064
    Juan Manuel Santos 36412963
    Juan Manuel Santos 95602761
    Juan Manuel Santos 68034431
    Juan Manuel Santos 822215673812119553
    Juan Manuel Santos 30313925
    Juan Manuel Santos 813286
    Juan Manuel Santos 260871480
    Juan Manuel Santos 1726815061
    Juan Manuel Santos 1430896860
    Juan Manuel Santos 214925195
    Juan Manuel Santos 94523600
    Juan Manuel Santos 548879712
    Juan Manuel Santos 50651755
    Juan Manuel Santos 630776121
    Juan Manuel Santos 455831037
    Juan Manuel Santos 740880151
    Juan Manuel Santos 1216071709
    Juan Manuel Santos 522398369
    Juan Manuel Santos 1537414225
    Juan Manuel Santos 1201567172
    Juan Manuel Santos 518979494
    Juan Manuel Santos 283284565
    Juan Manuel Santos 200170454
    Juan Manuel Santos 211336927
    Juan Manuel Santos 871993302
    Juan Manuel Santos 71103863
    Juan Manuel Santos 203079290
    Juan Manuel Santos 44442894
    Juan Manuel Santos 1117317140
    Juan Manuel Santos 336827083
    Juan Manuel Santos 92072502
    Juan Manuel Santos 173791558
    Juan Manuel Santos 138458064
    Juan Manuel Santos 240393857
    Juan Manuel Santos 74457555
    Juan Manuel Santos 260258821
    Juan Manuel Santos 551130311
    Juan Manuel Santos 113127283
    Juan Manuel Santos 116925166
    Juan Manuel Santos 142821215
    Juan Manuel Santos 38373082
    Juan Manuel Santos 52756754
    Juan Manuel Santos 133010778
    Juan Manuel Santos 46389700
    Juan Manuel Santos 57148575
    Juan Manuel Santos 148183388
    Juan Manuel Santos 69683409
    Juan Manuel Santos 110259026
    Juan Manuel Santos 219990061
    Juan Manuel Santos 167435593
    Juan Manuel Santos 415904558
    Juan Manuel Santos 119431745
    Juan Manuel Santos 195820318
    Juan Manuel Santos 110821941
    Juan Manuel Santos 55467753
    Juan Manuel Santos 242315288
    Juan Manuel Santos 79483727
    Juan Manuel Santos 148334426
    Juan Manuel Santos 172368909
    Juan Manuel Santos 321765070
    Juan Manuel Santos 252134272
    Juan Manuel Santos 241135651
    Juan Manuel Santos 110758478
    Juan Manuel Santos 264375065
    Juan Manuel Santos 53683972
    Juan Manuel Santos 95654761
    Juan Manuel Santos 186055140
    Juan Manuel Santos 306245721
    Juan Manuel Santos 194168803
    Juan Manuel Santos 119844526
    Juan Manuel Santos 73623870
    Juan Manuel Santos 219810356
    Juan Manuel Santos 214311943
    Juan Manuel Santos 40098182
    Juan Manuel Santos 197555620
    Juan Manuel Santos 288925780
    Juan Manuel Santos 186182226
    Juan Manuel Santos 204857228
    Juan Manuel Santos 164012673
    Juan Manuel Santos 182845963
    Juan Manuel Santos 111356236
    Juan Manuel Santos 217803304
    Juan Manuel Santos 139256389
    Juan Manuel Santos 200206843
    Juan Manuel Santos 171246248
    Juan Manuel Santos 378119331
    Juan Manuel Santos 327385337
    Juan Manuel Santos 153883560
    Juan Manuel Santos 129824582
    Juan Manuel Santos 187982680
    Juan Manuel Santos 91383477
    Juan Manuel Santos 54203675
    Juan Manuel Santos 287915407
    Juan Manuel Santos 296304120
    Juan Manuel Santos 38508530
    Juan Manuel Santos 338472735
    Juan Manuel Santos 213051585
    Juan Manuel Santos 151088536
    Juan Manuel Santos 242425204
    Juan Manuel Santos 191465222
    Juan Manuel Santos 615721665
    Juan Manuel Santos 595008217
    Juan Manuel Santos 346586565
    Juan Manuel Santos 85659017
    Juan Manuel Santos 442604298
    Juan Manuel Santos 122422941
    Juan Manuel Santos 253638345
    Juan Manuel Santos 281262004
    Juan Manuel Santos 227770132
    Juan Manuel Santos 193533203
    Juan Manuel Santos 181123681
    Juan Manuel Santos 467634392
    Juan Manuel Santos 17675072
    Juan Manuel Santos 56724999
    Juan Manuel Santos 75400667
    Juan Manuel Santos 34487135
    Juan Manuel Santos 498939116
    Juan Manuel Santos 404056067
    Juan Manuel Santos 887662308
    Juan Manuel Santos 1096370083
    Juan Manuel Santos 295657344
    Juan Manuel Santos 48144146
    Juan Manuel Santos 374096347
    Juan Manuel Santos 192990536
    Juan Manuel Santos 995849509
    Juan Manuel Santos 525264466
    Juan Manuel Santos 209780362
    Juan Manuel Santos 602853869
    Juan Manuel Santos 343447873
    Juan Manuel Santos 201363977
    Juan Manuel Santos 182983482
    Juan Manuel Santos 122005703
    Juan Manuel Santos 196752433
    Juan Manuel Santos 452417121
    Juan Manuel Santos 90978338
    Juan Manuel Santos 179584524
    Juan Manuel Santos 36425725
    Juan Manuel Santos 269036622
    Juan Manuel Santos 468436674
    Juan Manuel Santos 76664119
    Juan Manuel Santos 14050583
    Juan Manuel Santos 141762845
    Juan Manuel Santos 165569246
    Juan Manuel Santos 221210690
    Juan Manuel Santos 175806207
    Juan Manuel Santos 384008158
    Juan Manuel Santos 59177051
    Juan Manuel Santos 18730977
    Juan Manuel Santos 178529021
    Juan Manuel Santos 20801337
    Juan Manuel Santos 163987781
    Juan Manuel Santos 266234706
    Juan Manuel Santos 196463183
    Juan Manuel Santos 847387604
    Juan Manuel Santos 146998555
    Juan Manuel Santos 58531272
    Juan Manuel Santos 107139866
    Juan Manuel Santos 22804858
    Juan Manuel Santos 590107322
    Juan Manuel Santos 17614309
    Juan Manuel Santos 60984464
    Juan Manuel Santos 80318442
    Juan Manuel Santos 539145089
    Juan Manuel Santos 19882029
    Juan Manuel Santos 23719107
    Juan Manuel Santos 237372254
    Juan Manuel Santos 213840361
    Juan Manuel Santos 71074539
    Juan Manuel Santos 263283868
    Juan Manuel Santos 235601851
    Juan Manuel Santos 377173121
    Juan Manuel Santos 151624064
    Juan Manuel Santos 178718239
    Juan Manuel Santos 69396376
    Juan Manuel Santos 295876773
    Juan Manuel Santos 50859813
    Juan Manuel Santos 280701704
    Juan Manuel Santos 304303737
    Juan Manuel Santos 39823635
    Juan Manuel Santos 34140316
    Juan Manuel Santos 622082899
    Juan Manuel Santos 618242447
    Juan Manuel Santos 64791701
    Juan Manuel Santos 38227815
    Juan Manuel Santos 37748192
    Juan Manuel Santos 164434425
    Juan Manuel Santos 71543713
    Juan Manuel Santos 131340470
    Juan Manuel Santos 85908523
    Juan Manuel Santos 270326631
    Juan Manuel Santos 31052939
    Juan Manuel Santos 35051515
    Juan Manuel Santos 259093382
    Juan Manuel Santos 247498394
    Juan Manuel Santos 164425871
    Juan Manuel Santos 70759130
    Juan Manuel Santos 458052572
    Juan Manuel Santos 271551368
    Juan Manuel Santos 280799144
    Juan Manuel Santos 142021639
    Juan Manuel Santos 47672271
    Juan Manuel Santos 14122939
    Juan Manuel Santos 242730842
    Juan Manuel Santos 57174405
    Juan Manuel Santos 176395929
    Juan Manuel Santos 174443391
    Juan Manuel Santos 134634494
    Juan Manuel Santos 157566073
    Juan Manuel Santos 139508438
    Juan Manuel Santos 27570569
    Juan Manuel Santos 224400256
    Juan Manuel Santos 168285907
    Juan Manuel Santos 231112057
    Juan Manuel Santos 334921284
    Juan Manuel Santos 118563867
    Juan Manuel Santos 142849205
    Juan Manuel Santos 266893089
    Juan Manuel Santos 53236186
    Juan Manuel Santos 268307042
    Juan Manuel Santos 77694285
    Juan Manuel Santos 497511506
    Juan Manuel Santos 563986412
    Juan Manuel Santos 458755731
    Juan Manuel Santos 30861738
    Juan Manuel Santos 18804414
    Juan Manuel Santos 478892632
    Juan Manuel Santos 176931171
    Juan Manuel Santos 461567449
    Juan Manuel Santos 138813733
    Juan Manuel Santos 408665677
    Juan Manuel Santos 69051397
    Juan Manuel Santos 381725074
    Juan Manuel Santos 148825438
    Juan Manuel Santos 371797057
    Juan Manuel Santos 133112225
    Juan Manuel Santos 300541155
    Juan Manuel Santos 262398126
    Juan Manuel Santos 207661354
    Juan Manuel Santos 143924206
    Juan Manuel Santos 306248882
    Juan Manuel Santos 345214995
    Juan Manuel Santos 259905646
    Juan Manuel Santos 161306075
    Juan Manuel Santos 142250577
    Juan Manuel Santos 151190865
    Juan Manuel Santos 358598666
    Juan Manuel Santos 142306651
    Juan Manuel Santos 142454580
    Juan Manuel Santos 126672796
    Juan Manuel Santos 91181758
    Juan Manuel Santos 144376833
    Juan Manuel Santos 312887235
    Juan Manuel Santos 89707185
    Juan Manuel Santos 198540232
    Juan Manuel Santos 60205266
    Juan Manuel Santos 150327476
    Juan Manuel Santos 35884380
    Juan Manuel Santos 52767320
    Juan Manuel Santos 48158155
    Juan Manuel Santos 82174460
    Juan Manuel Santos 142968962
    Juan Manuel Santos 131273553
    Juan Manuel Santos 84094440
    Juan Manuel Santos 43726057
    Juan Manuel Santos 47491330
    Juan Manuel Santos 70030192
    Juan Manuel Santos 54037566
    Juan Manuel Santos 144315319
    Juan Manuel Santos 131596061
    Juan Manuel Santos 128276963
    Juan Manuel Santos 66740100
    Juan Manuel Santos 69432342
    Juan Manuel Santos 43395943
    Juan Manuel Santos 40680083
    Juan Manuel Santos 136112883
    Juan Manuel Santos 89207433
    Juan Manuel Santos 43255955
    Juan Manuel Santos 112412293
    Juan Manuel Santos 91488267
    Juan Manuel Santos 90558638
    Juan Manuel Santos 7540212
    Juan Manuel Santos 64419705
    Juan Manuel Santos 40996173
    Juan Manuel Santos 41048726
    Juan Manuel Santos 60619634
    Juan Manuel Santos 67962687
    Juan Manuel Santos 89208583
    Juan Manuel Santos 57625303
    Juan Manuel Santos 32720990
    Juan Manuel Santos 44409004
    Juan Manuel Santos 45580261
    Juan Manuel Santos 123594022
    Juan Manuel Santos 39657191
    Juan Manuel Santos 18079284
    Juan Manuel Santos 53187962
    Juan Manuel Santos 15404821
    Juan Manuel Santos 98781946
    Juan Manuel Santos 15930883
    Juan Manuel Santos 135543313
    Juan Manuel Santos 40918718
    Juan Manuel Santos 14287409
    Juan Manuel Santos 78138151
    Juan Manuel Santos 818925774493405188
    Juan Manuel Santos 24752484
    Juan Manuel Santos 14511951
    Juan Manuel Santos 17990493
    Juan Manuel Santos 20479813
    Juan Manuel Santos 15458694
    Juan Manuel Santos 14246001
    Juan Manuel Santos 17074440
    Juan Manuel Santos 101895924
    Juan Manuel Santos 21982720
    Juan Manuel Santos 35977487
    Juan Manuel Santos 9624742
    Juan Manuel Santos 108717093
    Juan Manuel Santos 20456814
    Juan Manuel Santos 83917616
    Juan Manuel Santos 97100000
    Juan Manuel Santos 126204564
    Juan Manuel Santos 133056567
    Juan Manuel Santos 58650958
    Juan Manuel Santos 35785401
    Juan Manuel Santos 134855279
    Juan Manuel Santos 17542529
    Juan Manuel Santos 20214495
    Juan Manuel Santos 79585327
    Juan Manuel Santos 17813487
    Juan Manuel Santos 19236074
    Juan Manuel Santos 40533752
    Juan Manuel Santos 35013719
    Juan Manuel Santos 14834302
    Juan Manuel Santos 69123952
    Juan Manuel Santos 85867670
    Juan Manuel Santos 23547038
    Juan Manuel Santos 44946232
    Juan Manuel Santos 20560294
    Juan Manuel Santos 83842614
    Juan Manuel Santos 94409405
    Juan Manuel Santos 31162623
    Juan Manuel Santos 13623532
    Juan Manuel Santos 26256322
    Juan Manuel Santos 38022021
    Juan Manuel Santos 22488241
    Juan Manuel Santos 15007299
    Juan Manuel Santos 69117279
    Juan Manuel Santos 44197786
    Juan Manuel Santos 41147203
    Juan Manuel Santos 49681553
    Juan Manuel Santos 68514004
    Juan Manuel Santos 68506967
    Juan Manuel Santos 24654312
    Juan Manuel Santos 56583257
    Juan Manuel Santos 18256297
    Juan Manuel Santos 28622388
    Juan Manuel Santos 17617530
    Juan Manuel Santos 9633802
    Juan Manuel Santos 64291532
    Juan Manuel Santos 47288005
    Juan Manuel Santos 24376343
    Juan Manuel Santos 55009852
    Juan Manuel Santos 56385497
    Juan Manuel Santos 53082010
    Juan Manuel Santos 38670671
    Juan Manuel Santos 37758638
    Juan Manuel Santos 25185308
    Juan Manuel Santos 44740326
    Juan Manuel Santos 24696904
    Juan Manuel Santos 21938850
    Humberto de la Calle 951999757995606018
    Humberto de la Calle 382419827
    Humberto de la Calle 303811814
    Humberto de la Calle 2152066729
    Humberto de la Calle 15128977
    Humberto de la Calle 103550181
    Humberto de la Calle 211317107
    Humberto de la Calle 178545797
    Humberto de la Calle 773344929615601664
    Humberto de la Calle 458946262
    Humberto de la Calle 93473418
    Humberto de la Calle 915939739353698304
    Humberto de la Calle 45647162
    Humberto de la Calle 29576447
    Humberto de la Calle 131875646
    Humberto de la Calle 126192998
    Humberto de la Calle 609313061
    Humberto de la Calle 63537045
    Humberto de la Calle 361508754
    Humberto de la Calle 56208761
    Humberto de la Calle 34124487
    Humberto de la Calle 202900470
    Humberto de la Calle 987640963
    Humberto de la Calle 128326052
    Humberto de la Calle 148152933
    Humberto de la Calle 274820136
    Humberto de la Calle 38554094
    Humberto de la Calle 82915992
    Humberto de la Calle 128738224
    Humberto de la Calle 314133536
    Humberto de la Calle 358947489
    Humberto de la Calle 279230693
    Humberto de la Calle 141943866
    Humberto de la Calle 1295316679
    Humberto de la Calle 54690970
    Humberto de la Calle 922541924564832258
    Humberto de la Calle 921187567902642176
    Humberto de la Calle 943483285778419715
    Humberto de la Calle 49212876
    Humberto de la Calle 64026038
    Humberto de la Calle 797197784
    Humberto de la Calle 135303262
    Humberto de la Calle 57226252
    Humberto de la Calle 1202671862
    Humberto de la Calle 264802537
    Humberto de la Calle 1104996810
    Humberto de la Calle 177441428
    Humberto de la Calle 819998376385253378
    Humberto de la Calle 3290187851
    Humberto de la Calle 730398504145801216
    Humberto de la Calle 943870494922739712
    Humberto de la Calle 127925615
    Humberto de la Calle 1052853600
    Humberto de la Calle 251857829
    Humberto de la Calle 2197086420
    Humberto de la Calle 530826233
    Humberto de la Calle 856011243475406848
    Humberto de la Calle 383579991
    Humberto de la Calle 102171561
    Humberto de la Calle 147705809
    Humberto de la Calle 101736223
    Humberto de la Calle 224865888
    Humberto de la Calle 142964547
    Humberto de la Calle 87356295
    Humberto de la Calle 1119557190
    Humberto de la Calle 303482958
    Humberto de la Calle 2296242860
    Humberto de la Calle 821052720081752064
    Humberto de la Calle 300518361
    Humberto de la Calle 111356236
    Humberto de la Calle 1116909056
    Humberto de la Calle 874700641
    Humberto de la Calle 34111296
    Humberto de la Calle 735614124672077824
    Humberto de la Calle 127912978
    Humberto de la Calle 629694239
    Humberto de la Calle 77047295
    Humberto de la Calle 80936145
    Humberto de la Calle 305876654
    Humberto de la Calle 60161414
    Humberto de la Calle 248760009
    Humberto de la Calle 114577790
    Humberto de la Calle 138093954
    Humberto de la Calle 346920954
    Humberto de la Calle 196633043
    Humberto de la Calle 65982125
    Humberto de la Calle 910349744777687043
    Humberto de la Calle 252134272
    Humberto de la Calle 46459012
    Humberto de la Calle 131605619
    Humberto de la Calle 81194477
    Humberto de la Calle 290086826
    Humberto de la Calle 324123105
    Humberto de la Calle 315875739
    Humberto de la Calle 279996897
    Humberto de la Calle 166424118
    Humberto de la Calle 99139328
    Humberto de la Calle 261790253
    Humberto de la Calle 128360779
    Humberto de la Calle 62437588
    Humberto de la Calle 341351402
    Humberto de la Calle 35392624
    Humberto de la Calle 1128606644
    

    Rate limit reached. Sleeping for: 723
    

    Humberto de la Calle 189580784
    Humberto de la Calle 115781856
    Humberto de la Calle 478208264
    Humberto de la Calle 142820741
    Humberto de la Calle 104036441
    Humberto de la Calle 55598030
    Humberto de la Calle 239941199
    Humberto de la Calle 811710451
    Humberto de la Calle 134538219
    Humberto de la Calle 2945094544
    Humberto de la Calle 2462262589
    Humberto de la Calle 156695400
    Humberto de la Calle 124809915
    Humberto de la Calle 757797813220540416
    Humberto de la Calle 948869570
    Humberto de la Calle 30725771
    Humberto de la Calle 2881162246
    Humberto de la Calle 928271461390757888
    Humberto de la Calle 280013355
    Humberto de la Calle 155031277
    Humberto de la Calle 928068629551337472
    Humberto de la Calle 926428023666237440
    Humberto de la Calle 928002324064296960
    Humberto de la Calle 926637549698928640
    Humberto de la Calle 50651755
    Humberto de la Calle 809528304227274752
    Humberto de la Calle 325313115
    Humberto de la Calle 258920818
    Humberto de la Calle 171648389
    Humberto de la Calle 2617594346
    Humberto de la Calle 388391016
    Humberto de la Calle 202165376
    Humberto de la Calle 161755007
    Humberto de la Calle 269888365
    Humberto de la Calle 876567714374049793
    Humberto de la Calle 49062170
    Humberto de la Calle 353945754
    Humberto de la Calle 760970024798527488
    Humberto de la Calle 886036450332090368
    Humberto de la Calle 890767118656045056
    Humberto de la Calle 611284268
    Humberto de la Calle 313699301
    Humberto de la Calle 360610171
    Humberto de la Calle 936102277
    Humberto de la Calle 2722649543
    Humberto de la Calle 2345783911
    Humberto de la Calle 930410389
    Humberto de la Calle 3063900359
    Humberto de la Calle 305920282
    Humberto de la Calle 2506638579
    Humberto de la Calle 834554797491683328
    Humberto de la Calle 144868217
    Humberto de la Calle 4843749791
    Humberto de la Calle 889498298473738240
    Humberto de la Calle 841357176744603649
    Humberto de la Calle 2274776624
    Humberto de la Calle 371299937
    Humberto de la Calle 2692292811
    Humberto de la Calle 705040803295584256
    Humberto de la Calle 821931133566910466
    Humberto de la Calle 178781692
    Humberto de la Calle 392863835
    Humberto de la Calle 944968700
    Humberto de la Calle 498363872
    Humberto de la Calle 334608970
    Humberto de la Calle 1689005894
    Humberto de la Calle 217984048
    Humberto de la Calle 499131358
    Humberto de la Calle 4698678872
    Humberto de la Calle 106812414
    Humberto de la Calle 255021410
    Humberto de la Calle 1380500774
    Humberto de la Calle 904876728
    Humberto de la Calle 2328728105
    Humberto de la Calle 295378710
    Humberto de la Calle 2516823312
    Humberto de la Calle 278600715
    Humberto de la Calle 519941023
    Humberto de la Calle 897513653687246849
    Humberto de la Calle 144317613
    Humberto de la Calle 2535936437
    Humberto de la Calle 1462226330
    Humberto de la Calle 401691967
    Humberto de la Calle 399802793
    Humberto de la Calle 51809973
    Humberto de la Calle 1024802360
    Humberto de la Calle 205817067
    Humberto de la Calle 58096733
    Humberto de la Calle 729160027559366659
    Humberto de la Calle 59376633
    Humberto de la Calle 261461246
    Humberto de la Calle 715717697280032769
    Humberto de la Calle 232328192
    Humberto de la Calle 486926802
    Humberto de la Calle 221829786
    Humberto de la Calle 1318721971
    Humberto de la Calle 543057590
    Humberto de la Calle 146349040
    Humberto de la Calle 206843308
    Humberto de la Calle 95478780
    Humberto de la Calle 253305789
    Humberto de la Calle 59908340
    Humberto de la Calle 782715162226728964
    Humberto de la Calle 902708308330590212
    Humberto de la Calle 1007758939
    Humberto de la Calle 155738943
    Humberto de la Calle 572255645
    Humberto de la Calle 2376902758
    Humberto de la Calle 150721426
    Humberto de la Calle 455416995
    Humberto de la Calle 2349469652
    Humberto de la Calle 3376072774
    Humberto de la Calle 311224196
    Humberto de la Calle 243641792
    Humberto de la Calle 190793512
    Humberto de la Calle 222349887
    Humberto de la Calle 282117909
    Humberto de la Calle 1545963174
    Humberto de la Calle 395392941
    Humberto de la Calle 3093754361
    Humberto de la Calle 1596816468
    Humberto de la Calle 142886103
    Humberto de la Calle 411582457
    Humberto de la Calle 38321105
    Humberto de la Calle 161046405
    Humberto de la Calle 537822087
    Humberto de la Calle 222329445
    Humberto de la Calle 345116281
    Humberto de la Calle 168206645
    Humberto de la Calle 1572968515
    Humberto de la Calle 151711504
    Humberto de la Calle 35752148
    Humberto de la Calle 935584963
    Humberto de la Calle 4138612679
    Humberto de la Calle 4503884733
    Humberto de la Calle 353766410
    Humberto de la Calle 525932086
    Humberto de la Calle 159246899
    Humberto de la Calle 76931020
    Humberto de la Calle 493757534
    Humberto de la Calle 2969082617
    Humberto de la Calle 62139079
    Humberto de la Calle 476403615
    Humberto de la Calle 1923674496
    Humberto de la Calle 127680067
    Humberto de la Calle 118417882
    Humberto de la Calle 107833175
    Humberto de la Calle 139753896
    Humberto de la Calle 1109094056
    Humberto de la Calle 520448524
    Humberto de la Calle 172156486
    Humberto de la Calle 310951187
    Humberto de la Calle 151679636
    Humberto de la Calle 268405094
    Humberto de la Calle 2663340049
    Humberto de la Calle 3805257737
    Humberto de la Calle 831705443923812352
    Humberto de la Calle 127345411
    Humberto de la Calle 230298236
    Humberto de la Calle 225092792
    Humberto de la Calle 65233678
    Humberto de la Calle 304697553
    Humberto de la Calle 382226980
    Humberto de la Calle 84929126
    Humberto de la Calle 204535022
    Humberto de la Calle 250207908
    Humberto de la Calle 2881594719
    Humberto de la Calle 2450564094
    Humberto de la Calle 136488167
    Humberto de la Calle 47476972
    Humberto de la Calle 15398299
    Humberto de la Calle 788434901905313792
    Humberto de la Calle 268086493
    Humberto de la Calle 449269613
    Humberto de la Calle 125685714
    Humberto de la Calle 125867827
    Humberto de la Calle 409558113
    Humberto de la Calle 940131985
    Humberto de la Calle 543045409
    Humberto de la Calle 285570358
    Humberto de la Calle 760160477108441089
    Humberto de la Calle 437491724
    Humberto de la Calle 592129412
    Humberto de la Calle 143058201
    Humberto de la Calle 2866498365
    Humberto de la Calle 127986967
    Humberto de la Calle 59003878
    Humberto de la Calle 118916657
    Humberto de la Calle 1714455816
    Humberto de la Calle 115486601
    Humberto de la Calle 427757025
    Humberto de la Calle 197168074
    Humberto de la Calle 2980771535
    Humberto de la Calle 883034568
    Humberto de la Calle 1450524626
    Humberto de la Calle 2476173026
    Humberto de la Calle 1630866234
    Humberto de la Calle 493723897
    Humberto de la Calle 67513712
    Humberto de la Calle 63488216
    Humberto de la Calle 93861756
    Humberto de la Calle 850517148233551872
    Humberto de la Calle 132649797
    Humberto de la Calle 348512630
    Humberto de la Calle 80353633
    Humberto de la Calle 3296860287
    Humberto de la Calle 212377468
    Humberto de la Calle 66562195
    Humberto de la Calle 276208306
    Humberto de la Calle 305620049
    Humberto de la Calle 79606760
    Humberto de la Calle 304705051
    Humberto de la Calle 48918065
    Humberto de la Calle 629785720
    Humberto de la Calle 55426584
    Humberto de la Calle 2222768279
    Humberto de la Calle 2216422623
    Humberto de la Calle 87541535
    Humberto de la Calle 17117121
    Humberto de la Calle 363928917
    Humberto de la Calle 476898485
    Humberto de la Calle 185808997
    Humberto de la Calle 64279030
    Humberto de la Calle 1077447373
    Humberto de la Calle 182628031
    Humberto de la Calle 27101841
    Humberto de la Calle 200779805
    Humberto de la Calle 403160520
    Humberto de la Calle 289942744
    Humberto de la Calle 4871384632
    Humberto de la Calle 309953999
    Humberto de la Calle 1177168352
    Humberto de la Calle 238632560
    Humberto de la Calle 48356019
    Humberto de la Calle 453404298
    Humberto de la Calle 160194192
    Humberto de la Calle 164969574
    Humberto de la Calle 197452136
    Humberto de la Calle 284085851
    Humberto de la Calle 277814940
    Humberto de la Calle 126496431
    Humberto de la Calle 1095934417
    Humberto de la Calle 1668581118
    Humberto de la Calle 2244024735
    Humberto de la Calle 95513301
    Humberto de la Calle 182222916
    Humberto de la Calle 987636385
    Humberto de la Calle 593219648
    Humberto de la Calle 887700266891522049
    Humberto de la Calle 1399914055
    Humberto de la Calle 533246309
    Humberto de la Calle 288294442
    Humberto de la Calle 39535404
    Humberto de la Calle 1711548704
    Humberto de la Calle 307683779
    Humberto de la Calle 120397230
    Humberto de la Calle 860723078
    Humberto de la Calle 320333675
    Humberto de la Calle 309878441
    Humberto de la Calle 68881468
    Humberto de la Calle 24177898
    Humberto de la Calle 2452187495
    Humberto de la Calle 386160781
    Humberto de la Calle 230823610
    Humberto de la Calle 984676927
    Humberto de la Calle 99469969
    Humberto de la Calle 365551675
    Humberto de la Calle 325146704
    Humberto de la Calle 425313348
    Humberto de la Calle 261479369
    Humberto de la Calle 202333729
    Humberto de la Calle 19579400
    Humberto de la Calle 1514101916
    Humberto de la Calle 24560310
    Humberto de la Calle 20954673
    Humberto de la Calle 1354646353
    Humberto de la Calle 1194952860
    Humberto de la Calle 515500644
    Humberto de la Calle 2239301473
    Humberto de la Calle 275746792
    Humberto de la Calle 561694515
    Humberto de la Calle 53445854
    Humberto de la Calle 136698973
    Humberto de la Calle 216865371
    Humberto de la Calle 2704665922
    Humberto de la Calle 48373749
    Humberto de la Calle 183243670
    Humberto de la Calle 251774200
    Humberto de la Calle 148996782
    Humberto de la Calle 225991519
    Humberto de la Calle 232388741
    Humberto de la Calle 186572665
    Humberto de la Calle 62987369
    Humberto de la Calle 168285907
    Humberto de la Calle 58645164
    Humberto de la Calle 2876523593
    Humberto de la Calle 65459531
    Humberto de la Calle 1114396933
    Humberto de la Calle 186468775
    Humberto de la Calle 116518454
    Humberto de la Calle 30680663
    Humberto de la Calle 268088390
    Humberto de la Calle 923693461
    Humberto de la Calle 1270393770
    Humberto de la Calle 1166418662
    Humberto de la Calle 59976153
    Humberto de la Calle 2245477346
    Humberto de la Calle 192737698
    Humberto de la Calle 131967740
    Humberto de la Calle 2232074215
    Humberto de la Calle 176899182
    Humberto de la Calle 40074137
    Humberto de la Calle 424386209
    Humberto de la Calle 382157490
    Humberto de la Calle 227755839
    Humberto de la Calle 369751562
    Humberto de la Calle 174758615
    Humberto de la Calle 67662252
    Humberto de la Calle 307441531
    Humberto de la Calle 59880726
    Humberto de la Calle 1915504502
    Humberto de la Calle 824689122426187777
    Humberto de la Calle 65132748
    Humberto de la Calle 23338236
    Humberto de la Calle 69024873
    Humberto de la Calle 883112808
    Humberto de la Calle 76192187
    Humberto de la Calle 135024942
    Humberto de la Calle 129549067
    Humberto de la Calle 785983018901135361
    Humberto de la Calle 346613519
    Humberto de la Calle 136011137
    Humberto de la Calle 47021969
    Humberto de la Calle 155703444
    Humberto de la Calle 49145792
    Humberto de la Calle 27831149
    Humberto de la Calle 197447394
    Humberto de la Calle 45587675
    Humberto de la Calle 701956728
    Humberto de la Calle 1416699630
    Humberto de la Calle 401751536
    Humberto de la Calle 53740016
    Humberto de la Calle 2477553956
    Humberto de la Calle 1080873181
    Humberto de la Calle 143200681
    Humberto de la Calle 58683469
    Humberto de la Calle 1071660367
    Humberto de la Calle 327429651
    Humberto de la Calle 64518293
    Humberto de la Calle 77368403
    Humberto de la Calle 158505123
    Humberto de la Calle 311129700
    Humberto de la Calle 190481385
    Humberto de la Calle 34791761
    Humberto de la Calle 519964119
    Humberto de la Calle 126799034
    Humberto de la Calle 52763369
    Humberto de la Calle 286965274
    Humberto de la Calle 310922654
    Humberto de la Calle 116482572
    Humberto de la Calle 105528257
    Humberto de la Calle 715002912
    Humberto de la Calle 287302346
    Humberto de la Calle 122778381
    Humberto de la Calle 754212613
    Humberto de la Calle 863598180
    Humberto de la Calle 142469128
    Humberto de la Calle 468794446
    Humberto de la Calle 173536054
    Humberto de la Calle 2906222974
    Humberto de la Calle 225986166
    Humberto de la Calle 314840449
    Humberto de la Calle 799108422365020160
    Humberto de la Calle 167204771
    Humberto de la Calle 325775822
    Humberto de la Calle 2608971303
    Humberto de la Calle 402321578
    Humberto de la Calle 200358733
    Humberto de la Calle 471981663
    Humberto de la Calle 377552697
    Humberto de la Calle 487085934
    Humberto de la Calle 300670697
    Humberto de la Calle 35626747
    Humberto de la Calle 239847413
    Humberto de la Calle 62062440
    Humberto de la Calle 553075553
    Humberto de la Calle 156828621
    Humberto de la Calle 892240802482704385
    Humberto de la Calle 391128209
    Humberto de la Calle 98146434
    Humberto de la Calle 298699930
    Humberto de la Calle 202848941
    Humberto de la Calle 591120106
    Humberto de la Calle 536616115
    Humberto de la Calle 224800938
    Humberto de la Calle 77513769
    Humberto de la Calle 70534171
    Humberto de la Calle 87720969
    Humberto de la Calle 254114448
    Humberto de la Calle 107554347
    Humberto de la Calle 1071349639
    Humberto de la Calle 858548027409281024
    Humberto de la Calle 2568410591
    Humberto de la Calle 87040123
    Humberto de la Calle 783561060
    Humberto de la Calle 295927749
    Humberto de la Calle 305142099
    Humberto de la Calle 178563034
    Humberto de la Calle 2645028393
    Humberto de la Calle 177310302
    Humberto de la Calle 83607004
    Humberto de la Calle 532461406
    Humberto de la Calle 2450115339
    Humberto de la Calle 109136139
    Humberto de la Calle 373497806
    Humberto de la Calle 270049668
    Humberto de la Calle 264443218
    Humberto de la Calle 3173158689
    Humberto de la Calle 165567718
    Humberto de la Calle 218617968
    Humberto de la Calle 96881293
    Humberto de la Calle 186558280
    Humberto de la Calle 118190586
    Humberto de la Calle 186256412
    Humberto de la Calle 2394836774
    Humberto de la Calle 3483933082
    Humberto de la Calle 117852718
    Humberto de la Calle 142820755
    Humberto de la Calle 314899831
    Humberto de la Calle 843967450135838720
    Humberto de la Calle 2293806169
    Humberto de la Calle 295344199
    Humberto de la Calle 274291771
    Humberto de la Calle 70539007
    Humberto de la Calle 2990147632
    Humberto de la Calle 52429642
    Humberto de la Calle 162447300
    Humberto de la Calle 118278172
    Humberto de la Calle 389223585
    Humberto de la Calle 395012801
    Humberto de la Calle 207312967
    Humberto de la Calle 1623783648
    Humberto de la Calle 50706735
    Humberto de la Calle 123594022
    Humberto de la Calle 1622201900
    Humberto de la Calle 3001337748
    Humberto de la Calle 57403718
    Humberto de la Calle 801391295352733698
    Humberto de la Calle 864513125437067264
    Humberto de la Calle 69659744
    Humberto de la Calle 39863994
    Humberto de la Calle 53981491
    Humberto de la Calle 145904821
    Humberto de la Calle 3338958202
    Humberto de la Calle 137914940
    Humberto de la Calle 4889381914
    Humberto de la Calle 40368195
    Humberto de la Calle 707004777524281345
    Humberto de la Calle 157758110
    Humberto de la Calle 133143825
    Humberto de la Calle 242638754
    Humberto de la Calle 513748493
    Humberto de la Calle 169500428
    Humberto de la Calle 198629176
    Humberto de la Calle 14982931
    Humberto de la Calle 356509389
    Humberto de la Calle 133926244
    Humberto de la Calle 3307380094
    Humberto de la Calle 885929467981508608
    Humberto de la Calle 149199445
    Humberto de la Calle 62273618
    Humberto de la Calle 57174405
    Humberto de la Calle 18441350
    Humberto de la Calle 73923825
    Humberto de la Calle 201301319
    Humberto de la Calle 783181572
    Humberto de la Calle 906765860
    Humberto de la Calle 347599612
    Humberto de la Calle 345574315
    Humberto de la Calle 572136250
    Humberto de la Calle 36276135
    Humberto de la Calle 327553766
    Humberto de la Calle 299724078
    Humberto de la Calle 1135574096
    Humberto de la Calle 40315392
    Humberto de la Calle 512606990
    Humberto de la Calle 159691467
    Humberto de la Calle 3033043527
    Humberto de la Calle 346047922
    Humberto de la Calle 224499373
    Humberto de la Calle 78920906
    Humberto de la Calle 147960463
    Humberto de la Calle 12583602
    Humberto de la Calle 456977489
    Humberto de la Calle 4821251483
    Humberto de la Calle 42780156
    Humberto de la Calle 348218155
    Humberto de la Calle 171365054
    Humberto de la Calle 250459343
    Humberto de la Calle 205500871
    Humberto de la Calle 83457960
    Humberto de la Calle 20548476
    Humberto de la Calle 129007805
    Humberto de la Calle 189863173
    Humberto de la Calle 142714135
    Humberto de la Calle 134483495
    Humberto de la Calle 156377580
    Humberto de la Calle 68755646
    Humberto de la Calle 60247069
    Humberto de la Calle 864991963778605056
    Humberto de la Calle 770662232183144449
    Humberto de la Calle 60613480
    Humberto de la Calle 117109734
    Humberto de la Calle 247911158
    Humberto de la Calle 1244682984
    Humberto de la Calle 191465222
    Humberto de la Calle 478892632
    Humberto de la Calle 298163347
    Humberto de la Calle 219990061
    Humberto de la Calle 1667809860
    Humberto de la Calle 131596061
    Humberto de la Calle 161306075
    Humberto de la Calle 259905646
    Humberto de la Calle 2157729691
    Humberto de la Calle 807095
    Humberto de la Calle 91181758
    Humberto de la Calle 116476719
    Humberto de la Calle 126672796
    Humberto de la Calle 3246781065
    Humberto de la Calle 186227903
    Humberto de la Calle 36087400
    Humberto de la Calle 178718239
    Humberto de la Calle 270326631
    Humberto de la Calle 78188601
    Humberto de la Calle 129683990
    Humberto de la Calle 999594384
    Humberto de la Calle 156456941
    Humberto de la Calle 156457945
    Humberto de la Calle 213856259
    Humberto de la Calle 322884518
    Humberto de la Calle 867099413507956737
    Humberto de la Calle 26060210
    Humberto de la Calle 79483727
    Humberto de la Calle 591936074
    Humberto de la Calle 1216071709
    Humberto de la Calle 44946232
    Humberto de la Calle 182845963
    Humberto de la Calle 266893089
    Humberto de la Calle 2259447348
    Humberto de la Calle 201363977
    Humberto de la Calle 30861738
    Humberto de la Calle 204876189
    Humberto de la Calle 250624558
    Humberto de la Calle 64839766
    Humberto de la Calle 20456814
    Humberto de la Calle 140933970
    Humberto de la Calle 2499219806
    Humberto de la Calle 41147203
    Humberto de la Calle 846826482387369988
    Humberto de la Calle 155216270
    Humberto de la Calle 1733793840
    Humberto de la Calle 2519392123
    Humberto de la Calle 14884514
    Humberto de la Calle 131273553
    Humberto de la Calle 218592577
    Humberto de la Calle 2713176725
    Humberto de la Calle 2602616060
    Humberto de la Calle 240268656
    Humberto de la Calle 22123078
    Humberto de la Calle 15346918
    Humberto de la Calle 39313353
    Humberto de la Calle 59459771
    Humberto de la Calle 747891746512736256
    Humberto de la Calle 142849205
    Humberto de la Calle 87713796
    Humberto de la Calle 720382613446270977
    Humberto de la Calle 22386555
    Humberto de la Calle 142454580
    Humberto de la Calle 606657005
    Humberto de la Calle 139518091
    Humberto de la Calle 56599191
    Humberto de la Calle 140140285
    Humberto de la Calle 768533872564895744
    Humberto de la Calle 66571267
    Humberto de la Calle 44151017
    Humberto de la Calle 113451138
    Humberto de la Calle 2731985244
    Humberto de la Calle 516101547
    Humberto de la Calle 248001840
    Humberto de la Calle 522627214
    Humberto de la Calle 809049564128935936
    Humberto de la Calle 213441704
    Humberto de la Calle 103646160
    Humberto de la Calle 46831967
    Humberto de la Calle 2762868178
    Humberto de la Calle 153148677
    Humberto de la Calle 175864992
    Humberto de la Calle 47672271
    Humberto de la Calle 3108351
    Humberto de la Calle 91478624
    Humberto de la Calle 5988062
    Humberto de la Calle 373138480
    Humberto de la Calle 438393937
    Humberto de la Calle 280701704
    Humberto de la Calle 705484506
    Humberto de la Calle 179584524
    Humberto de la Calle 101486124
    Humberto de la Calle 71629877
    Humberto de la Calle 371797057
    Humberto de la Calle 615721665
    Humberto de la Calle 141366885
    Humberto de la Calle 89707185
    Humberto de la Calle 174693068
    Humberto de la Calle 281262004
    Humberto de la Calle 138813733
    Humberto de la Calle 296304120
    Humberto de la Calle 32211946
    Humberto de la Calle 308257399
    Humberto de la Calle 1324417764
    Humberto de la Calle 170714191
    Humberto de la Calle 142968962
    Humberto de la Calle 136112883
    Humberto de la Calle 262814659
    Humberto de la Calle 150327476
    Humberto de la Calle 70202338
    Humberto de la Calle 215862333
    Humberto de la Calle 300962869
    Humberto de la Calle 250149384
    Humberto de la Calle 164425871
    Humberto de la Calle 2400080066
    Humberto de la Calle 310385299
    Humberto de la Calle 14050583
    Humberto de la Calle 308156854
    Humberto de la Calle 783333972885573632
    Humberto de la Calle 767058898788425728
    Humberto de la Calle 2810685413
    Humberto de la Calle 130829150
    Humberto de la Calle 213787737
    Humberto de la Calle 3401638840
    Humberto de la Calle 742143
    Humberto de la Calle 87818409
    Humberto de la Calle 315220400
    Humberto de la Calle 106091939
    Humberto de la Calle 62337495
    Humberto de la Calle 444813339
    Humberto de la Calle 346586565
    Humberto de la Calle 589717092
    Humberto de la Calle 766210752
    Humberto de la Calle 582140078
    Humberto de la Calle 595008217
    Humberto de la Calle 77653794
    Humberto de la Calle 193533203
    Humberto de la Calle 2469313506
    Humberto de la Calle 3109346535
    Humberto de la Calle 106610881
    Humberto de la Calle 247498394
    Humberto de la Calle 197922102
    Humberto de la Calle 271686451
    Humberto de la Calle 3413313155
    Humberto de la Calle 2202387091
    Humberto de la Calle 191116947
    Humberto de la Calle 1473434310
    Humberto de la Calle 461590140
    Humberto de la Calle 2191265078
    Humberto de la Calle 868853900
    Humberto de la Calle 95025617
    Humberto de la Calle 19923515
    Humberto de la Calle 14436030
    Humberto de la Calle 7996082
    Humberto de la Calle 10012122
    Humberto de la Calle 33884545
    Humberto de la Calle 90558638
    Humberto de la Calle 265945808
    Humberto de la Calle 61243172
    Humberto de la Calle 770432345644105728
    Humberto de la Calle 12542002
    Humberto de la Calle 78442816
    Humberto de la Calle 568638386
    Humberto de la Calle 143669232
    Humberto de la Calle 149109242
    Humberto de la Calle 100668216
    Humberto de la Calle 91288610
    Humberto de la Calle 374573334
    Humberto de la Calle 17572957
    Humberto de la Calle 6003222
    Humberto de la Calle 21860431
    Humberto de la Calle 2279705827
    Humberto de la Calle 34345168
    Humberto de la Calle 465628233
    Humberto de la Calle 590702211
    Humberto de la Calle 191603726
    Humberto de la Calle 170079568
    Humberto de la Calle 240402139
    Humberto de la Calle 195905174
    Humberto de la Calle 135321834
    Humberto de la Calle 47753979
    Humberto de la Calle 174443391
    Humberto de la Calle 34798360
    Humberto de la Calle 97452391
    Humberto de la Calle 243680902
    Humberto de la Calle 104861330
    Humberto de la Calle 149912984
    Humberto de la Calle 57664761
    Humberto de la Calle 49849732
    Humberto de la Calle 108717093
    Humberto de la Calle 3351175753
    Humberto de la Calle 17617530
    Humberto de la Calle 21938850
    Humberto de la Calle 62945553
    Humberto de la Calle 37341338
    Humberto de la Calle 165748292
    Humberto de la Calle 133112225
    Humberto de la Calle 3300493816
    Humberto de la Calle 58650958
    Humberto de la Calle 69432342
    Humberto de la Calle 338472735
    Humberto de la Calle 312887235
    Humberto de la Calle 213051585
    Humberto de la Calle 75400667
    Humberto de la Calle 242425204
    Humberto de la Calle 175806207
    Humberto de la Calle 151088536
    Humberto de la Calle 40918718
    Humberto de la Calle 473338133
    Humberto de la Calle 631580827
    Humberto de la Calle 39955069
    Humberto de la Calle 2865328068
    Humberto de la Calle 68861723
    Humberto de la Calle 152010594
    Humberto de la Calle 151624064
    Humberto de la Calle 39683468
    Humberto de la Calle 202644027
    Humberto de la Calle 163961519
    Humberto de la Calle 143285665
    Humberto de la Calle 66711542
    Humberto de la Calle 124355265
    Humberto de la Calle 69135570
    Humberto de la Calle 757563559001919488
    Humberto de la Calle 281182832
    Humberto de la Calle 52756754
    Humberto de la Calle 48253393
    Humberto de la Calle 74201578
    Humberto de la Calle 129834397
    Humberto de la Calle 154670681
    Humberto de la Calle 138206058
    Humberto de la Calle 50442705
    Humberto de la Calle 737454919205171200
    Humberto de la Calle 244659783
    Humberto de la Calle 1450133648
    Humberto de la Calle 1425639174
    Humberto de la Calle 2874285407
    Humberto de la Calle 1267204351
    Humberto de la Calle 38650624
    Humberto de la Calle 3171885767
    Humberto de la Calle 770378969153671169
    Humberto de la Calle 518979494
    Humberto de la Calle 98781946
    Humberto de la Calle 112829676
    Humberto de la Calle 64791701
    Humberto de la Calle 31162623
    Humberto de la Calle 38670671
    Humberto de la Calle 268322810
    Humberto de la Calle 62154340
    Humberto de la Calle 747169903
    Humberto de la Calle 1201567172
    Humberto de la Calle 126832572
    Humberto de la Calle 3374091909
    Humberto de la Calle 1897857392
    Humberto de la Calle 189189288
    Humberto de la Calle 40988451
    Humberto de la Calle 626592458
    Humberto de la Calle 108382552
    Humberto de la Calle 565490620
    Humberto de la Calle 827942701077299201
    Humberto de la Calle 353088691
    Humberto de la Calle 219508242
    Humberto de la Calle 200267797
    Humberto de la Calle 237465026
    Humberto de la Calle 133945128
    Humberto de la Calle 201432345
    Humberto de la Calle 44186827
    Humberto de la Calle 60619634
    Humberto de la Calle 64419705
    Humberto de la Calle 18079284
    Humberto de la Calle 14834302
    Humberto de la Calle 9633802
    Humberto de la Calle 67654599
    Humberto de la Calle 40533752
    Humberto de la Calle 79585327
    Humberto de la Calle 126204564
    Humberto de la Calle 35013719
    Humberto de la Calle 622082899
    Humberto de la Calle 41048726
    Humberto de la Calle 17813487
    Humberto de la Calle 906610164
    Humberto de la Calle 15930883
    Humberto de la Calle 19236074
    Humberto de la Calle 326920504
    Humberto de la Calle 134855279
    Humberto de la Calle 154294030
    Humberto de la Calle 174492304
    Humberto de la Calle 253315622
    Humberto de la Calle 20560294
    Humberto de la Calle 334921284
    Humberto de la Calle 29442313
    Humberto de la Calle 24376343
    Humberto de la Calle 242730842
    Humberto de la Calle 337783129
    Humberto de la Calle 22488241
    Humberto de la Calle 1339835893
    Humberto de la Calle 137908875
    Humberto de la Calle 25185308
    


```python
#quick unicode data clean
#I want to strip all accents from letters FIRST to avoid unicode errors going into R
#locations were being interpreted into R as "PopayÃ¡n, Colombia", etc. 

import unidecode
with open('friends_cleaned.csv', 'w', encoding='utf-8') as csvfile:
    writer = csv.writer(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
    with open('friends.csv', 'r', encoding='utf-8') as friends:
        reader = csv.reader(friends, delimiter=',', quotechar='"')   #quotechar is needed so that the commas in the string don't
        for row in reader:                                           #split the location into two. (e.g. "Bogota, Colombia")
            if len(row) > 0:  #only run this function on non-missing data
                location = row[4]
                cleaned_location = unidecode.unidecode(location).strip('"') #first removes accents, then removes " " in the csv
                print(location, cleaned_location) #make sure it's working right by
                new_row = list(row)               #printing old string and new string
                new_row[4] = cleaned_location
                writer.writerow(new_row)
                
            
    

```

    location location
    Barbosa, Colombia Barbosa, Colombia
    Colombia, Panamá y USA Colombia, Panama y USA
    Universidad de los Andes Universidad de los Andes
    Bogotá, DC, Colombia Bogota, DC, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Armenia, Colombia Armenia, Colombia
     
    Bogotá, D.C. Colombia Bogota, D.C. Colombia
     
     
     
     
    Medellín Medellin
     
     
    Ciudad Star Ciudad Star
    Santander - Colombia Santander - Colombia
     
    Medellín, Colombia Medellin, Colombia
    Partido Conservador Partido Conservador
     
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Cualquier lugar Cualquier lugar
    Medellín, Antioquia Medellin, Antioquia
     
     
     
     
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Bogotá, DC, Colombia Bogota, DC, Colombia
    Risaralda, Colombia Risaralda, Colombia
     
    COLOMBIA COLOMBIA
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Montes de María (Col.) Montes de Maria (Col.)
     
    Zipaquirá Zipaquira
    Medellin, Colombia Medellin, Colombia
    Colombia Colombia
     
     
    Chía, Colombia Chia, Colombia
    Mérida, Venezuela Merida, Venezuela
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogota Colombia Bogota Colombia
    Bogota Bogota
    Cúcuta NdeS Cucuta NdeS
     
    Cartagena, Colombia Cartagena, Colombia
    Colombia Colombia
    Fort Lauderdale, FL Fort Lauderdale, FL
    BOGOTA COLOMBIA BOGOTA COLOMBIA
     
    Colombia Colombia
    Medellín, Colombia Medellin, Colombia
    Quito Quito
    Ferrol Ferrol
    London, England London, England
    colombia colombia
    Colombia Colombia
     
    Piedecuesta, Colombia Piedecuesta, Colombia
    COLOMBIA COLOMBIA
     
    te hablo desde la prisión... te hablo desde la prision...
     
    En el País Mojigato En el Pais Mojigato
     
    Barranquilla Barranquilla
    United States United States
    Venezuela Venezuela
    Bogotá Bogota
    Península Antártica 🇦🇶 Peninsula Antartica 
     
    Medellín, Colombia Medellin, Colombia
    Puerto Asis Putumayo Puerto Asis Putumayo
     
    Caracas, Venezuela Caracas, Venezuela
    Mosquera, Colombia Mosquera, Colombia
     
     
     
    España Espana
     
     
    en una Venezuela sana y en paz en una Venezuela sana y en paz
     
    GUAJIRA GUAJIRA
    Medellín, Colombia Medellin, Colombia
     
    Medellin Medellin
     
    Medellín, Colombia Medellin, Colombia
    Bogota Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    En Chibchombia  En Chibchombia 
     
     
    Bogotá Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Lejos de Santos Lejos de Santos
    Bogotá Bogota
    Belém, Brasília e São Paulo Belem, Brasilia e Sao Paulo
     
     
    Bogotá, Colombia Bogota, Colombia
    West Palm Beach, FL West Palm Beach, FL
    Constitución 1886 Constitucion 1886
    Colombia Colombia
    Popayán Popayan
    Florencia Caqueta  Florencia Caqueta 
    EEUU EEUU
    Bucaramanga, Colombia Bucaramanga, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Medellín, Colombia Medellin, Colombia
     
    Bogotá Bogota
     
    Medellín Colombia Medellin Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Madrid, Roma  Madrid, Roma 
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Valle del Cauca, Colombia Valle del Cauca, Colombia
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Cali Colombia Cali Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá D.C. Bogota D.C.
     
    Santander, Colombia Santander, Colombia
    Cali, Colombia Cali, Colombia
    Bogotá  Bogota 
    Sincelejo, Sucre Sincelejo, Sucre
    Washington D.C. Washington D.C.
    Bogota Bogota
    Bogota Bogota
     
    Antioquia - Colombia Antioquia - Colombia
    Cúcuta, Colombia Cucuta, Colombia
    Colombia Colombia
    medellin medellin
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
     
    Colombia Colombia
    Rio de Janeiro, Brazil Rio de Janeiro, Brazil
    Santiago, Chile Santiago, Chile
    Popayán, Colombia Popayan, Colombia
    Colombia Colombia
    En el mar de la felicidad. En el mar de la felicidad.
     
    Bogotá - Valledupar Bogota - Valledupar
     
     
     
     
    Bogotá Bogota
     
    Caracas, Venezuela Caracas, Venezuela
    Aguascalientes, México Aguascalientes, Mexico
     
    Medellín, Colombia Medellin, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Medellín, Colombia Medellin, Colombia
    Valle del Cauca, Colombia Valle del Cauca, Colombia
     
    Ibagué, Tolima Ibague, Tolima
    ReinoUnido ReinoUnido
    Medellín, Antioquia Medellin, Antioquia
    Colombia Colombia
    Colombia Colombia
    Los Angeles, CA Los Angeles, CA
    Medellín - Colombia Medellin - Colombia
    Bucaramanga Bucaramanga
    Bogotá  Bogota 
    RT's aren't endorsements. RT's aren't endorsements.
    Barrancabermeja, Colombia Barrancabermeja, Colombia
    Medellín, Colombia Medellin, Colombia
    Colombia Colombia
    Bogota Bogota
    Fusagasugá, Colombia Fusagasuga, Colombia
    Colombia en 2017 Colombia en 2017
     
    Medellín, Antioquia Medellin, Antioquia
    San Antonio de Cusicancha, Per San Antonio de Cusicancha, Per
    Venezuela Venezuela
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogota, Colombia Bogota, Colombia
    Miami, Fl Miami, Fl
    Madrid / Bogota  Madrid / Bogota 
    Madrid,España .  Madrid,Espana . 
    Colombia Colombia
    Cali - Colombia Cali - Colombia
    Cali, Valle del Cauca,Colombia Cali, Valle del Cauca,Colombia
     
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Colombia Colombia
    cartagena cartagena
    Bogotá, Colombia Bogota, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Valledupar, Colombia Valledupar, Colombia
    Rionegro (Antioquia) Rionegro (Antioquia)
    Colombia Colombia
    ARIZONA ARIZONA
     
     
     
    Lugano, Switzerland Lugano, Switzerland
    Bogotá Bogota
     
    Santander, Colombia Santander, Colombia
    Yopal, Colombia Yopal, Colombia
    Fotos de: Teresa Vargas. Fotos de: Teresa Vargas.
    Bogotá Bogota
    Washington, DC Washington, DC
    Narnia Narco Bananera  Narnia Narco Bananera 
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    New York, NY New York, NY
    colombia-bogotá colombia-bogota
    Atlanta, GA Atlanta, GA
    Villavicencio, Meta Villavicencio, Meta
     
    Cartagena de Indias Cartagena de Indias
     
     
    Barranquilla Barranquilla
    Medellin - Colombia  Medellin - Colombia 
    Colombia Colombia
    Medellín, Colombia Medellin, Colombia
    México, DF Mexico, DF
    Bogotá Bogota
    Guatemala Guatemala
    Guatemala Guatemala
    Colombia Colombia
     
     
     
    Casanare / Yopal Bogota  Casanare / Yopal Bogota 
    Ecuador Ecuador
    Bucaramanga, Colombia Bucaramanga, Colombia
     
    Colombia Colombia
    Venezuela Venezuela
    Bogotá - Colombia Bogota - Colombia
    Bogotà. Colombia Bogota. Colombia
    Caracas, Venezuela Caracas, Venezuela
    CHINÁcota - Marinilla  CHINAcota - Marinilla 
     
     
    Bogotá, Colombia Bogota, Colombia
    Floridablanca, Colombia Floridablanca, Colombia
    Santiago- Chile Santiago- Chile
    República de Panamá Republica de Panama
     
    Bogotá, D.C.,  Barranquilla Bogota, D.C.,  Barranquilla
    Cúcuta - Colombia Cucuta - Colombia
    Bogota y Neiva Bogota y Neiva
    Popayán, Colombia Popayan, Colombia
    Pasadena, CA Pasadena, CA
    Bogota Bogota
     
    Quindio, Colombia Quindio, Colombia
     
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Bolivar - Colombia Bolivar - Colombia
    Cartagena bolívar Cartagena bolivar
    Barranquilla Barranquilla
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
     
    Colombia Colombia
     
    Bogota DC Bogota DC
     
    Valle del Cauca, Colombia Valle del Cauca, Colombia
    Ginebra, Colombia Ginebra, Colombia
    En algun lugar de la Mancha  En algun lugar de la Mancha 
    San Vicente del Caguan  San Vicente del Caguan 
    Cundinamarca, Colombia Cundinamarca, Colombia
    Cartagena de Indias Cartagena de Indias
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Tuluá - Valle, COLOMBIA Tulua - Valle, COLOMBIA
     
    Colombia Colombia
    Saturno Saturno
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Medellín Medellin
     
    Colombia Colombia
     
    Medellín, Antioquia, Colombia. Medellin, Antioquia, Colombia.
    Aqui en mi llano  Aqui en mi llano 
    Caracas Caracas
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    COLOMBIA COLOMBIA
    Santa Marta, Colombia Santa Marta, Colombia
    Con el corazón en Venezuela Con el corazon en Venezuela
     
    Colombia Colombia
    Bogota D.C. Bogota D.C.
    En cualquier paraiso En cualquier paraiso
    Portugal Portugal
    Venezuela Venezuela
    Antioquia, Colombia Antioquia, Colombia
    Colombia Colombia
    En España por ahora  En Espana por ahora 
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Barranquilla - Colombia Barranquilla - Colombia
    Bucaramanga - Santander Bucaramanga - Santander
    Miami, FL Miami, FL
    Miami-México-Caracas-Madrid Miami-Mexico-Caracas-Madrid
    Abuja, Nigeria. Abuja, Nigeria.
    Caracas Venezuela Caracas Venezuela
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    France France
    Maracaibo, Venezuela Maracaibo, Venezuela
    Colombia Colombia
    Valledupar, Colombia Valledupar, Colombia
    España Espana
    El Caribe colombiano El Caribe colombiano
    Colombia Colombia
    Planeta Namekusei Planeta Namekusei
    Soacha - Cundinamarca Soacha - Cundinamarca
     
    Fort Lauderdale, FL Fort Lauderdale, FL
    Colombia Colombia
    Ciudad de México Ciudad de Mexico
    Peñol, Colombia Penol, Colombia
     
     
    Colombia Colombia
     
    Bogotá  Bogota 
    Miami, FL Miami, FL
     
     
    Villavicencio- Meta Villavicencio- Meta
    Tonga Tonga
     
    Medellín, Colombia Medellin, Colombia
    Medellín Medellin
    Estados Unidos Estados Unidos
    Santiago, Chile Santiago, Chile
    Antioquia, Colombia Antioquia, Colombia
     
    Muelle de San Blas Muelle de San Blas
    Washington, DC Washington, DC
     
    Medellin  Medellin 
    Washington, D.C. Washington, D.C.
     
    Valledupar, Colombia Valledupar, Colombia
    New York, USA New York, USA
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Medellin -Antioquia -Colombia Medellin -Antioquia -Colombia
    Colombia Colombia
    América Latina America Latina
    Colombia Colombia
    Colombia Colombia
    Popayán, Colombia Popayan, Colombia
    Banana Republic Banana Republic
    Aquí tomando martinis🍸 Aqui tomando martinis
    bogota colombia bogota colombia
     
    Spain Spain
    Venezuela Venezuela
     
    Caracas, Venezuela Caracas, Venezuela
     
    🍃 Colombia 🍃  Colombia 
     
    Colombia Colombia
     
    Premio Simon Bolivar 2009 Premio Simon Bolivar 2009
     
    lorica cordoba lorica cordoba
    Santa Marta- Colombia Santa Marta- Colombia
    Santa Marta,D.T.C.H. Santa Marta,D.T.C.H.
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    United States United States
     
     
    Rionegro, Colombia Rionegro, Colombia
     
     
    Somos LA DERECHA Somos LA DERECHA
    Medellín, Colombia. Medellin, Colombia.
    Colombia Colombia
    Bogotá Bogota
    Colombia Colombia
    Caquetá,Meta y Guaviare  Caqueta,Meta y Guaviare 
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá  Bogota 
     
    Ocaña Ocana
     
     
     
    Cundinamarca, Colombia Cundinamarca, Colombia
     
    Victoria, Tamaulipas Victoria, Tamaulipas
     
     
    Estado Sucre Estado Sucre
    Manhattan, NY Manhattan, NY
    Cali - Valle del Cauca, Colombia Cali - Valle del Cauca, Colombia
    #Venezuela  #Venezuela 
    Caracas, Venezuela Caracas, Venezuela
    Medellín Medellin
    Washington, D.C. Washington, D.C.
     
     
     
    Región Caribe Region Caribe
    Medellín-Antioquia Medellin-Antioquia
     
     
    Bogotá, DC, Colombia Bogota, DC, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Neiva Neiva
    Cartagena, Colombia Cartagena, Colombia
    United States United States
    Suma tu firma en @CubaDecide  Suma tu firma en @CubaDecide 
     
     
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    NEW JERSEY NEW JERSEY
    Medellín Medellin
    Colombia Colombia
    Bogotá D. C. Bogota D. C.
    Cartago, Colombia Cartago, Colombia
     
     
     
     
    São Paulo Sao Paulo
     
    América Latina America Latina
    Saravena, Arauca Saravena, Arauca
    Colombia Colombia
     
    Ciudadano del mundo Ciudadano del mundo
    Colombia  Colombia 
    colombia colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, Colombia Bogota, Colombia
    SIN RUMBO FIJO....... SIN RUMBO FIJO.......
    Ocaña, N de S, Colombia Ocana, N de S, Colombia
     
    Medellín  Medellin 
     
    Narino Narino
     
     
    Cartagena, Colombia Cartagena, Colombia
    Colombia Colombia
     
    Colombia Colombia
    Bogotá Bogota
    Pereira, Risaralda Pereira, Risaralda
    Medellín, Colombia Medellin, Colombia
    Colombia Colombia
    Medellín, Antioquia, Colombia Medellin, Antioquia, Colombia
    Medellín, Antioquia, Colombia Medellin, Antioquia, Colombia
    Medellín Medellin
    IdeasLocalesQueConstruyenPais  IdeasLocalesQueConstruyenPais 
    Medellín, Antioquia Medellin, Antioquia
    Colombia Colombia
     
    Guayaquil, Ecuador Guayaquil, Ecuador
    Colombia - U.S.A Colombia - U.S.A
    Venezuela Venezuela
    Venezuela Venezuela
    Al lado de mi bella esposa Al lado de mi bella esposa
    Colombia Colombia
    Cucuta, Norte de Santander Cucuta, Norte de Santander
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia  Colombia 
     
    Bucaramanga, Colombia Bucaramanga, Colombia
     
    Guatape, Colombia Guatape, Colombia
    Medellín, Colombia Medellin, Colombia
    Medellín, Colombia Medellin, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Medellín Medellin
    Colombia Colombia
    Colombia Colombia
     
    Washington, D.C. Washington, D.C.
    Washington, D.C. Washington, D.C.
    Bogotá, Colombia Bogota, Colombia
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Carabobo Venezuela Carabobo Venezuela
    Venezuela Venezuela
    Bogota Bogota
    Colombia Colombia
    Colombia Colombia
    Stanford, CA Stanford, CA
    Colombia Colombia
    Geneva, Switzerland Geneva, Switzerland
     
    Colombia Colombia
    Asuncion, Paraguay Asuncion, Paraguay
    Washington, DC Washington, DC
    Villavicencio(Meta) Villavicencio(Meta)
    Planeta Tierra Planeta Tierra
     
    Bogota,Colombia Bogota,Colombia
    Bogotá, Colombia Bogota, Colombia
    Florida, USA Florida, USA
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Caracas, Venezuela Caracas, Venezuela
    Colombia Colombia
     
    Florencia, Colombia Florencia, Colombia
     
    Colombia-Venezuela  Colombia-Venezuela 
     
     
    Phoenix, AZ / Washington, DC Phoenix, AZ / Washington, DC
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Medellín, Antioquia Medellin, Antioquia
    Madrid, España Madrid, Espana
    colombia colombia
     
    Quito,Ecuador Quito,Ecuador
    Berkeley, CA Berkeley, CA
    Santa Marta Santa Marta
    Narnialombia Narnialombia
    Chapecó Chapeco
    Bogotá - Colombia Bogota - Colombia
     
    Montevideo, Uruguay Montevideo, Uruguay
    La Calera Cundinamarca La Calera Cundinamarca
     
    BOGOTA BOGOTA
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    CALI COLOMBIA CALI COLOMBIA
    Valle del Cauca, Colombia Valle del Cauca, Colombia
    Bogotá Bogota
    Bogotá Bogota
     
     
    Cali Cali
     
    Kenosha, WI and Washington, DC Kenosha, WI and Washington, DC
    hell hell
     
    United States United States
    Antioquia, Colombia Antioquia, Colombia
     
    Montería, Colombia Monteria, Colombia
    Andes, Colombia Andes, Colombia
     
    SPAIN SPAIN
    Colombia Colombia
    Zurich-Suiza Zurich-Suiza
     
    U.S.A. U.S.A.
    Madrid, Cundinamarca Madrid, Cundinamarca
    Bogotá Bogota
    Barranquilla, Colombia Barranquilla, Colombia
    Cartagena Cartagena
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
     
     
    Medellin Medellin
    Medellin Medellin
    Please do not DM🚫 Please do not DM
     
    Continente Americano Continente Americano
     
    Barranquilla  Barranquilla 
     
    Colombia Colombia
     
    Caracas - Venezuela Caracas - Venezuela
    Popayán, Colombia Popayan, Colombia
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Quindío, Colombia Quindio, Colombia
    Bogotá Bogota
    Colombia Colombia
    ibague ibague
    Medellín, Antioquia, Colombia Medellin, Antioquia, Colombia
    United States United States
    Colombia Colombia
     
    Columbia Columbia
    BOGOTA BOGOTA
    Colombia Colombia
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Medellín, Antioquia Medellin, Antioquia
     
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Chicago / Vatican City Chicago / Vatican City
    Quibdó, Colombia Quibdo, Colombia
    Costa Norte, Colombiana Costa Norte, Colombiana
     
    Colombia Colombia
    en todas partes en todas partes
     
    Bogotá, Colombia Bogota, Colombia
    COLOMBIA COLOMBIA
    Colombia Colombia
    Aquí y Ahora Aqui y Ahora
     
    Cali, Colombia Cali, Colombia
    Montes de Maria Montes de Maria
    Bogotá, Colombia Bogota, Colombia
    Cali, Colombia Cali, Colombia
    Medellín   #UnidosHacemosMás Medellin   #UnidosHacemosMas
    Matanza, Colombia Matanza, Colombia
    Cúcuta, Colombia Cucuta, Colombia
    BCN, MAD, BOG,STM BCN, MAD, BOG,STM
    New york-Italy-Mexico New york-Italy-Mexico
    Medellín, Colombia Medellin, Colombia
     
    Cali, Valle del Cauca Cali, Valle del Cauca
    Guatape, Colombia Guatape, Colombia
     
     
    Colombia Colombia
     
     
    BOGOTA D.C. - COLOMBIA BOGOTA D.C. - COLOMBIA
    Bogotá, Colombia Bogota, Colombia
    Medellín Medellin
     
    Colombia Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Canada Canada
    Bogotá Colombia Bogota Colombia
     
     
     
    MANIZALES MANIZALES
    Antioquia es mi gran Orgullo Antioquia es mi gran Orgullo
    EL SANTUARIO ANTIOQUIA EL SANTUARIO ANTIOQUIA
    COLOMBIA COLOMBIA
    Madrid Madrid
    En cualquier lugar del mundo. En cualquier lugar del mundo.
    DC-area DC-area
     
    Colombia Colombia
    Colombia Colombia
    Cali colombia Cali colombia
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Medellín, Colombia Medellin, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    PANAMA PANAMA
    siempre sere siempre sere
    Madrid, España Madrid, Espana
    El mundo  El mundo 
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Bogotá, Colombia Bogota, Colombia
    Brasil Brasil
     
    Bogota Bogota
    Colombia Colombia
     
    Miami, Florida Miami, Florida
    Medellín Medellin
    Northern Ireland Northern Ireland
    Ireland Ireland
    Colombia Colombia
     
    Everywhere Everywhere
    Medellin. Colombia  Medellin. Colombia 
     
    Bogota Bogota
    BOGOTA D.C BOGOTA D.C
    Sincelejo, Colombia Sincelejo, Colombia
    Bogotá - Colombia Bogota - Colombia
    Madrid, España Madrid, Espana
    The Hague, The Netherlands The Hague, The Netherlands
    Venezuela Venezuela
    GORILANDIA GORILANDIA
     
     
    Madrid Cundinamarca Colombia Madrid Cundinamarca Colombia
     
    Palmetto Bay, FL Palmetto Bay, FL
    Cali, Bogotá, Colombia Cali, Bogota, Colombia
    República Dominicana Republica Dominicana
    Madrid, Spain - Nueva York,USA Madrid, Spain - Nueva York,USA
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Caracas, Venezuela Caracas, Venezuela
    Ibagué Tolima Ibague Tolima
    Ecuador Ecuador
    Yopal - Casanare Yopal - Casanare
    Chile Chile
    Colombia Colombia
    New York, NY New York, NY
    Bucaramanga, Colombia Bucaramanga, Colombia
     
    Barranquilla, Colombia Barranquilla, Colombia
    Colombia Colombia
    Tunja, Boyacá Tunja, Boyaca
     
     
    France France
    Soy de allá, pero vivo acá. Soy de alla, pero vivo aca.
    San Diego, CA San Diego, CA
     
    Contacto: PUBLICIDADyC0NTACT0@outlook.com Contacto: PUBLICIDADyC0NTACT0@outlook.com
     
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    COLOMBIA-ESPAÑA COLOMBIA-ESPANA
    São Paulo, Brazil Sao Paulo, Brazil
    Colombia Colombia
     
     
    Venezuela Venezuela
    Boston, Milan, Titiribi Boston, Milan, Titiribi
     
     
    Valledupar, Colombia  Valledupar, Colombia 
    Bogotá - Bogota -
     
    We're Global! We're Global!
    Irvine, CA Irvine, CA
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    somewhereinthemiddleofnowhere somewhereinthemiddleofnowhere
     
    Miami , Florida Miami , Florida
    Colombia Colombia
     
    Czech Republic Czech Republic
    Colombia  Colombia 
    Colombia Colombia
     
    Colombia Colombia
    Lima - Perú Lima - Peru
    !!DE CALI-COLOMBIA!! !!DE CALI-COLOMBIA!!
    Australia Australia
    Ecuador Ecuador
    Batalla contra la ignorancia. Batalla contra la ignorancia.
    ULTRA DERECHA ULTRA DERECHA
    Cucuta, Colombia Cucuta, Colombia
     
     
    venezuela venezuela
    Con los pies en la Tierra Con los pies en la Tierra
     
    Miami, FL Miami, FL
    Colombia Colombia
    Miami, FL Miami, FL
    Apartadó, Colombia Apartado, Colombia
    Bogotá Bogota
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Cali, Colombia Cali, Colombia
    Venezuela Venezuela
    Ibagué, Colombia Ibague, Colombia
    Colombia Colombia
    Arauca Arauca
     
    Bogota Bogota
    Colombia Colombia
    VillanuevaLaGuajira - Colombia VillanuevaLaGuajira - Colombia
     
    cordoba cordoba
    Houston, Texas Houston, Texas
    El Mundo Mundial El Mundo Mundial
    Washington, DC Washington, DC
    Bucaramanga Bucaramanga
    καθ 'οδόν στην Ιθάκη kath 'odon sten Ithake
     
    Barranquilla, Atlántico Barranquilla, Atlantico
     
    @Bogotá @Bogota
    Proud Bostonian Proud Bostonian
    Florida & Washington, DC Florida & Washington, DC
     
    Colombia Colombia
    Washington, DC Washington, DC
    Bogotá Bogota
    Medellín,Colombia Medellin,Colombia
    Miami, FL Miami, FL
    Venezuela Venezuela
    Bogotá, Colombia Bogota, Colombia
    Venezuela Venezuela
    Bogotá - Colombia Bogota - Colombia
    Bogotá D.C, Colombia  Bogota D.C, Colombia 
    Caracas, Venezuela Caracas, Venezuela
     
    En todas partes/Everywhere. En todas partes/Everywhere.
    Colombia Colombia
    Puerto Santander, Colombia Puerto Santander, Colombia
    Madrid/Latin America Madrid/Latin America
     
    Vancouver, British Columbia Vancouver, British Columbia
     
    LIMA-PERU LIMA-PERU
    Bucaramanga, Colombia Bucaramanga, Colombia
    Las Américas Las Americas
     
    Colombia Colombia
     
    Around the globe Around the globe
    Cali Cali
    Geneva, Switzerland Geneva, Switzerland
    Colombia Colombia
    Colombia Colombia
     
     
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    United States United States
     
    Miami FL Miami FL
    Venezuela  Venezuela 
     
    México Mexico
    México Mexico
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, Colombia Bogota, Colombia
    Medellin- #TodoPorLaPatria Medellin- #TodoPorLaPatria
     
    Buenos Aires Buenos Aires
    Argentina Argentina
    Buenos Aires, Argentina Buenos Aires, Argentina
    Tallahassee, Florida Tallahassee, Florida
    Argentina Argentina
    London London
    Weston, FL Weston, FL
    EEUU EEUU
    Miami, Fl. Miami, Fl.
    Medellín Medellin
    Bogota, Colombia Bogota, Colombia
    Playa del Carmen Playa del Carmen
    Bogotá, Colombia Bogota, Colombia
    Birmingham-UK Medellin-COL Birmingham-UK Medellin-COL
     
     
     
    United States of América United States of America
    Medellín, Colombia Medellin, Colombia
    Metropolitana de Santiago Metropolitana de Santiago
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Chinchiná, Colombia Chinchina, Colombia
    Medellin Colombia Medellin Colombia
    Bogotá Bogota
    Cali, Colombia Cali, Colombia
     
    Bogotá Bogota
     
     
    En todas partes!! En todas partes!!
     
     
     
    Colombia Colombia
    San Francisco San Francisco
    Boston, MA Boston, MA
    Medellín Medellin
     
    Medellin Medellin
     
    Colombia Colombia
    Colombia Colombia
    Cundinamarca, Colombia Cundinamarca, Colombia
    Colombia Colombia
    Panamá Panama
     
    Bogotá, DC, Colombia Bogota, DC, Colombia
    Urabá Uraba
    Montería - Colombia Monteria - Colombia
    Bucaramanga Bucaramanga
    Who Knows Who Knows
    Colombia Colombia
    COLOMBIA COLOMBIA
    Guarne, Antioquia Guarne, Antioquia
    Envigado, Colombia Envigado, Colombia
    Santa Marta, Colombia Santa Marta, Colombia
    Medellín, Colombia Medellin, Colombia
    La Habana, Cuba La Habana, Cuba
    Estados Unidos Estados Unidos
    Envigado, Antioquia Envigado, Antioquia
    Guatemala Guatemala
    Valledupar, Cesar Valledupar, Cesar
     
    Colombia Colombia
     
    Antioquia Antioquia
     
    New York New York
     
    Cali Cali
    Spain Spain
    Colombia Colombia
     
    Bogotá  Bogota 
    Medellin, Colombia Medellin, Colombia
     
    Siempre a la derecha! Siempre a la derecha!
     
    Chapinero medio, Bogotá Chapinero medio, Bogota
     
     
    San Cristobal Venezuela San Cristobal Venezuela
     
     
     
    Colombia Colombia
    Miranda, Venezuela Miranda, Venezuela
    Quilla Quilla
     
     
     
    Plentzia, Bizkaia, España Plentzia, Bizkaia, Espana
    Cúcuta, Colombia Cucuta, Colombia
     
    Medellín Medellin
    Colombia Colombia
     
    Aldea Global Aldea Global
    Bogota Cundinamarca Bogota Cundinamarca
    (COLOMBIA) (COLOMBIA)
     
    Buenavista Cordoba - Montería  Buenavista Cordoba - Monteria 
     
    Córdoba, Colombia Cordoba, Colombia
     
     
     
    Colombia Colombia
     
    Caracas-Miami Caracas-Miami
     
     
    Maracaibo, Venezuela Maracaibo, Venezuela
     
    Estados Unidos- Colombia Estados Unidos- Colombia
    Atlanta GA Atlanta GA
    fort lauderdale fort lauderdale
     
    Quito-Ecuador Quito-Ecuador
     
     
    Duitama - Boyacá-Colombia 🇨🇴 Duitama - Boyaca-Colombia 
     
    Colombia Colombia
    Cúcuta Cucuta
    Colombia Colombia
    Leticia, Amazonas Leticia, Amazonas
    Santander, Colombia Santander, Colombia
    Bucaramanga Bucaramanga
    Medellin, Antioquia Medellin, Antioquia
    Colombia Colombia
    Colombia Colombia
    Madrid, España Madrid, Espana
    Santa Rosa de Cabal  Santa Rosa de Cabal 
     
    Colombia Colombia
    Colombia Colombia
    Esp en  Gerencia Empresarial Esp en  Gerencia Empresarial
    Bucaramanga Bucaramanga
    New York, NY New York, NY
    Gotham City Gotham City
    Barrancabermeja, Santander Barrancabermeja, Santander
    Nariño, Colombia Narino, Colombia
    Cuenta alternativa Cuenta alternativa
    Colombia Colombia
     
    Colombia Colombia
     
    Asuncion, Paraguay Asuncion, Paraguay
    Marinilla-Antioquia Marinilla-Antioquia
    Risaralda, Colombia Risaralda, Colombia
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    PERU PERU
     
    Bogotá, Colombia Bogota, Colombia
    Venezolano en el exilio Venezolano en el exilio
     
    Yopal/ Casanare Yopal/ Casanare
     
     
    España Espana
    el exilio el exilio
    NY, NY NY, NY
    Miami, FL Miami, FL
    La Ceja-La Unión(antioquia) La Ceja-La Union(antioquia)
     
     
     
    Medellin, Colombia Medellin, Colombia
    Bogotá Bogota
    Bogotá, Colombia Bogota, Colombia
     
    Bogota, Colombia Bogota, Colombia
    Turin, Piedmont Turin, Piedmont
     
     
    Bogota Bogota
     
    San José, Costa Rica San Jose, Costa Rica
    Tercera esfera entorno al sol Tercera esfera entorno al sol
    AQUI y ALLA  🤔👇👆COLOMBIA AQUI y ALLA  COLOMBIA
    Colombia Colombia
    Universidad Central de Venezuela Universidad Central de Venezuela
    Bogotá D.C Bogota D.C
    Venezuela Venezuela
    Bogotá, Colombia Bogota, Colombia
    Montería  Monteria 
    Colombia Colombia
    Colombia-Monteria- Colombia-Monteria-
    Bogotá Colombia Bogota Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Barranquilla COLOMBIA Barranquilla COLOMBIA
    Colombia Colombia
    England England
    Nyon, Vaud Nyon, Vaud
     
     
    Madrid, Spain Madrid, Spain
    Colombia Colombia
     
    Quibdó - Chocó Quibdo - Choco
    Caracas, Venezuela Caracas, Venezuela
    Bogotá Bogota
    Antioquia Antioquia
     
    Colombia Colombia
    Morelia, Michoacán Morelia, Michoacan
    Bogota, República de Colombia Bogota, Republica de Colombia
     
    Colombia Colombia
    Colombia Colombia
    COLOMBIA COLOMBIA
    Bucaramanga - Colombia  Bucaramanga - Colombia 
     
    Bucaramanga, Santander  Bucaramanga, Santander 
    EEUU-Chile EEUU-Chile
    Derecha - Soldado de Cristo Derecha - Soldado de Cristo
     
     
     
    Westminster, London Westminster, London
    10 Downing Street, London 10 Downing Street, London
    Algún lugar del Mundo! Algun lugar del Mundo!
    @elnuevoherald, @MiamiHerald @elnuevoherald, @MiamiHerald
    Ecuador Ecuador
    Ecuador Ecuador
    Bogota, NJ Bogota, NJ
     
    Venezuela Venezuela
     
    Montevideo, Uruguay Montevideo, Uruguay
    Colombia Colombia
    Miami-Bogotá, D.C., Colombia Miami-Bogota, D.C., Colombia
    Tuluá Tulua
    Medellin - Colombia Medellin - Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Barranquilla Barranquilla
    colombia colombia
    Venezuela Venezuela
     
    In the back of your mind In the back of your mind
    Madrid Madrid
    Coveñas, Colombia Covenas, Colombia
    Cali Cali
    Centro de la Ciudad de México Centro de la Ciudad de Mexico
    Buenos Aires, Argentina Buenos Aires, Argentina
    Tigre, Argentina. Tigre, Argentina.
    Colombia Colombia
     
    Valle del Cauca, Colombia Valle del Cauca, Colombia
    Bucaramanga Bucaramanga
     
    Bogota,Colombia Bogota,Colombia
    Armenia, Colombia Armenia, Colombia
    Suiza Suiza
     
    Cuenca, Ecuador Cuenca, Ecuador
     
     
     
    A  R  G  E  N  T  I  N  A A  R  G  E  N  T  I  N  A
    Estado civil:En desobediencia  Estado civil:En desobediencia 
    Venezuela Venezuela
    Bogotà Bogota
    camilina041289@hotmail.com  camilina041289@hotmail.com 
    U.S.A. U.S.A.
    Colombia Colombia
     
    En el Exilio  En el Exilio 
    Global Global
    Brasil Brasil
    Caracas, Venezuela Caracas, Venezuela
    Venezuela Venezuela
    Venezuela Venezuela
     
    COLOMBIA-PEREIRA COLOMBIA-PEREIRA
     
     
     
    Colombia Colombia
    San Francisco, CA San Francisco, CA
    Bogotá  Bogota 
    Valle del Cauca - Colombia Valle del Cauca - Colombia
    Villavicencio, Colombia Villavicencio, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Huila Huila
     
    Villavicencio - Meta Villavicencio - Meta
    Cali - Valle del Cauca Cali - Valle del Cauca
     
    Bogotá, Colombia Bogota, Colombia
    BOGOTA D.C BOGOTA D.C
    Chile Chile
    Chile Chile
    Colombia Tierra Querida!  Colombia Tierra Querida! 
     
    Colombia Colombia
     
    Cartagena, Colombia Cartagena, Colombia
    Cartagena, Colombia Cartagena, Colombia
     
     
    Florida Florida
     
    Cali, Colombia Cali, Colombia
    Bogotá Bogota
    Miami, FL Miami, FL
     
    On virtual World On virtual World
    Col Col
    Caldas-Bogotá Caldas-Bogota
    Cali Colombia Cali Colombia
    Colombia Colombia
     
    Ecuador Ecuador
     
    Florida, USA Florida, USA
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Colombia Colombia
    New York, NY New York, NY
    Venezuela Venezuela
     
    Colombia Colombia
    Dallas, TX Dallas, TX
    tunja tunja
    MIIAMI MIIAMI
     
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Montelibano, Cordoba Montelibano, Cordoba
    New York, NY New York, NY
     
    Basados en USGS Basados en USGS
    Antioquia, Colombia Antioquia, Colombia
    Miami - Florida, USA Miami - Florida, USA
    Bogotá - Colombia Bogota - Colombia
    Medellín Medellin
    En todas partes En todas partes
     
     
    Colombia Colombia
     
    Latinoamérica y el Caribe 🌎 Latinoamerica y el Caribe 
    Prisión política SEBIN Prision politica SEBIN
    Santiago, Chile Santiago, Chile
    Ecuador Ecuador
     
    Colombia Colombia
    Santiago, Chile. Santiago, Chile.
    Colombia Colombia
     
    ÜT: 4.813799,-75.693599 UT: 4.813799,-75.693599
    ocaña ocana
     
    Villavicencio, Colombia Villavicencio, Colombia
     
     
    La Costa Caribe La Costa Caribe
     
    Nigeria Nigeria
     
    New York City New York City
    colombia colombia
    Medellín Medellin
     
    Bogotá Bogota
    Bucaramanga, Santander Bucaramanga, Santander
    Bogotá Bogota
    Riohacha, La Guajira Riohacha, La Guajira
    Bogotá  Bogota 
    Colombia Colombia
     
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    América America
    Colombia Colombia
    California, USA California, USA
     
    New York, NY New York, NY
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Cenapromil - Los Teques Cenapromil - Los Teques
    Miami, Florida Miami, Florida
    New York Metro Area New York Metro Area
    Cali - Valle Cali - Valle
    Ecuador Ecuador
     
    Colombia Colombia
     
    Colombia  Colombia 
    Villavicencio, Meta Villavicencio, Meta
    Abu Dhabi, UAE Abu Dhabi, UAE
     
     
     
    Washington DC Washington DC
    New York, NY New York, NY
    Estado Lara Estado Lara
    Colombia Colombia
    Lara, Venezuela Lara, Venezuela
    Medellin  Medellin 
    Medellín, Colombia Medellin, Colombia
     
    X EL MUNDO!!! X EL MUNDO!!!
    Neiva Neiva
    Miami, Florida Miami, Florida
    Colombia Colombia
    políticamente correcto politicamente correcto
     
    Estados Unidos Estados Unidos
    Bogotá Bogota
    Medellín, Colombia Medellin, Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
     
    venezuela venezuela
     
    Colombia Colombia
     
    De Cali pero en Bogotá De Cali pero en Bogota
    Kathmandú, Nepal Kathmandu, Nepal
    Algún punto Algun punto
    Ibagué, Colombia Ibague, Colombia
    Munich, Baviera Munich, Baviera
    Colombia Colombia
    El Salvador, Centroamérica.  El Salvador, Centroamerica. 
    Colombia 🇨🇴 Colombia 
     
     
     
    Colombia Colombia
    Bogota Bogota
    Calle 70 # 10 A -39 Calle 70 # 10 A -39
    West Roxbury, Boston West Roxbury, Boston
    Colombia Colombia
    Medellín, Colombia Medellin, Colombia
    bogota. col bogota. col
    Bogotá, Barranquilla y Miami. Bogota, Barranquilla y Miami.
    Colombia  Colombia 
    Washington, D.C. Washington, D.C.
     
    ÜT: 4.707552,-74.050778 UT: 4.707552,-74.050778
    Colombia Colombia
     
     
     
     
     
    Bogotá D.C. Bogota D.C.
    Tanger Tanger
    Colombia Colombia
     
     
     
    Barranquilla, Colombia Barranquilla, Colombia
     
    Venezuela Venezuela
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    COLOMBIA COLOMBIA
    Spain Spain
    Bogotá D.C. Bogota D.C.
    medellin colombia medellin colombia
    Caracas, Venezuela Caracas, Venezuela
    Colombia Colombia
    Montería - Colombia Monteria - Colombia
    Montería, Colombia Monteria, Colombia
     
     
    Miami, Florida Miami, Florida
     
     
    Antioquia, Colombia Antioquia, Colombia
     
     
    Valencia-Vnzla Valencia-Vnzla
    España Espana
    En el país del nunca jamás En el pais del nunca jamas
    Colombia  Colombia 
     
    United States United States
    Alnortedelsur Alnortedelsur
    EL MUNDO EL MUNDO
    Barranquilla Colombia Barranquilla Colombia
     
    ÜT: 4.628989,-74.120165 UT: 4.628989,-74.120165
    Pereira- Colombia Pereira- Colombia
    Barranquilla Barranquilla
    Buenos Aires, Argentina Buenos Aires, Argentina
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
     
    El cráter derecho de la luna El crater derecho de la luna
    Colombia Colombia
    barranquilla barranquilla
    Miami Miami
    San Cristobal Venezuela San Cristobal Venezuela
    Caracas Caracas
     
    Colombia Colombia
     
    Ipiales Nariño  Ipiales Narino 
    Bucaramanga Bucaramanga
     
    Persia Persia
    Colombia  Colombia 
    Colombia Colombia
    Cali Cali
     
    New York City New York City
     
    México Mexico
    Washington DC Washington DC
    Colombia/España Colombia/Espana
     
    www.davidsantiago.web.ve www.davidsantiago.web.ve
    Not available Not available
     
    Boston, Massachusetts Boston, Massachusetts
    Barranquilla, Colombia Barranquilla, Colombia
    Medellín Medellin
    Antioquia, Colombia Antioquia, Colombia
    Bogotá Bogota
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    London London
     
    Cali, Colombia Cali, Colombia
    yarumal yarumal
     
    Caracas, Venezuela Caracas, Venezuela
    In The Moment In The Moment
    Bogotá Bogota
    Colombia Colombia
    Bogotá-Colombia Bogota-Colombia
    Bogotá Bogota
    Bogotá Bogota
    Medellín, Antioquia Medellin, Antioquia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Barranquilla. Colombia Barranquilla. Colombia
    Barranquilla Barranquilla
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Montería - Colombia Monteria - Colombia
     
     
    Cartagena, Colombia Cartagena, Colombia
     
    Barranquilla, Colombia  Barranquilla, Colombia 
     
    Popayán, Colombia Popayan, Colombia
     
    Bogota, Colombia Bogota, Colombia
    Colombia Colombia
     
    Puerto Ordaz Puerto Ordaz
    Cartagena / Colombia Cartagena / Colombia
     
     
    Bogotá/Colombia Bogota/Colombia
    Bogotá-Colombia Bogota-Colombia
    Huila - Colombia Huila - Colombia
    ahí ahi
     
    Bogota' Bogota'
    Medellin Medellin
    Bogotá, DC, Colombia Bogota, DC, Colombia
     
    London, UK London, UK
    Ciénaga, Colombia Cienaga, Colombia
    Washington, DC Washington, DC
    UNETE Y ESCRIBE  UNETE Y ESCRIBE 
    Rionegro Sector Gualanday Rionegro Sector Gualanday
    Santa Marta Santa Marta
    Colombia Colombia
    En Un Cafetal De Colombia En Un Cafetal De Colombia
    MEDELLÍN  MEDELLIN 
    Venezuela Venezuela
    Bogotá Bogota
     
    Medellin Medellin
     
     
    Bogotá Bogota
    Miami - Medellin Miami - Medellin
     
    Mexico City Mexico City
    Colombia and Spain Colombia and Spain
    Colombia Colombia
    bogota, colombia bogota, colombia
    viktuuriland viktuuriland
    bogota bogota
    Dagua Dagua
    New York, NY  New York, NY 
    La Paz La Paz
     
    Antioquia Antioquia
    Colombia Colombia
    Venezuela Venezuela
    Venezuela Venezuela
     
    Pitalito Pitalito
    Miami Miami
     
    Colombia Colombia
    Chia, Cundinamarca Chia, Cundinamarca
     
    Austin, TX Austin, TX
    Bogota, Colombia . Bogota, Colombia .
    medellin medellin
     
    Caracas - Venezuela Caracas - Venezuela
    Santa Tecla, El Salvador Santa Tecla, El Salvador
    San Francisco, CA San Francisco, CA
    Rionegro, Antioquia Colombia Rionegro, Antioquia Colombia
    Barranquilla Barranquilla
    Bogota D.C. - Colombia Bogota D.C. - Colombia
    City of London, London City of London, London
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Colombia Colombia
    Placetas, Villa Clara, Cuba Placetas, Villa Clara, Cuba
     
    Villavicencio, Meta Villavicencio, Meta
     
    Colombia Colombia
    Bogotá D.C. - Colombia Bogota D.C. - Colombia
    colombia colombia
    ÜT: 10.995413,-74.813665 UT: 10.995413,-74.813665
     
    Colombia Colombia
    DE COLOMBIA CON ORGULLO DE COLOMBIA CON ORGULLO
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Yopal, Casanare Yopal, Casanare
    PUJ-UNAL-Uniandes PUJ-UNAL-Uniandes
     
    Guatapé Guatape
    Colombia Colombia
    Asuncion - Paraguay Asuncion - Paraguay
    Colombia Colombia
     
     
    MEDELLIN MEDELLIN
     
     
    United States United States
    Bogotá, Colombia  Bogota, Colombia 
    Colombia Colombia
     
    Colombia Colombia
    Montelibano Cordoba Montelibano Cordoba
    Colombia Colombia
    Antioquia, Colombia Antioquia, Colombia
    Miami, FL Miami, FL
    Colombia Colombia
    Cartagena de Indias. Cartagena de Indias.
    Colombia Colombia
    Cartagena, Colombia Cartagena, Colombia
    Bogota Bogota
     
    Medellin - Antioquia Medellin - Antioquia
    South America South America
     
    Caracas, Venezuela Caracas, Venezuela
     
     
    Bogotá - Colombia Bogota - Colombia
    Miami, Florida. USA Miami, Florida. USA
    Honduras Honduras
     
    En toda Colombia En toda Colombia
    LATAM LATAM
    Latinoamérica Latinoamerica
    Bogotá Bogota
    Colombia Colombia
     
    Here, There, Everywhere  Here, There, Everywhere 
     
    LONDON LONDON
    Barranquilla, Colombia Barranquilla, Colombia
    Colombia  Colombia 
    Pas-de-Calais Pas-de-Calais
    Santa Fe de Bogotá, Colombia Santa Fe de Bogota, Colombia
    medellin medellin
    Medellin Medellin
     
    Neiva, Colombia Neiva, Colombia
     
    Cali Cali
    Bogotá Bogota
    planeta azul  planeta azul 
    Bogotá, D.C. Bogota, D.C.
    Colombia Colombia
     
    colombia colombia
    global global
    Cholombia Cholombia
    Bogotá, Colombia Bogota, Colombia
    Algún lugar del planeta Tierra Algun lugar del planeta Tierra
    Cali Colombia Cali Colombia
    Medellín - Colombia Medellin - Colombia
     
    San Bruno, CA San Bruno, CA
    Colombia Colombia
    COLOMBIA COLOMBIA
    Cali, Colombia Cali, Colombia
     
    Panama Panama
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
     
    Bogotá, Colombia Bogota, Colombia
    Envigado Envigado
    Paris Paris
    cali, colombia cali, colombia
    Bucaramanga - Santander Bucaramanga - Santander
     
    Bogotá, Colombia Bogota, Colombia
    Venezuela Venezuela
     
    Bogotá - COLOMBIA Bogota - COLOMBIA
     
    İstanbul  Istanbul 
    Estados Unidos Estados Unidos
    Medellín, Colombia / Washington, DC Medellin, Colombia / Washington, DC
    Colombia Colombia
    Bogotá D.C. Bogota D.C.
    Mexico Mexico
     
    Popayán - Cauca Popayan - Cauca
    Colombia Colombia
     
     
     
    ÜT: 10.6121364,-72.9733973 UT: 10.6121364,-72.9733973
     
    Yarumal Antioquia Colombia Yarumal Antioquia Colombia
     
    El Caribe, Colombia. El Caribe, Colombia.
    Asunción, Paraguay Asuncion, Paraguay
    Valledupar Valledupar
     
    Colombia Colombia
    Venezuela Venezuela
    ÜT: 4.2119656,-74.6848978 UT: 4.2119656,-74.6848978
     
     
    Cartagena, Colombia Cartagena, Colombia
    Colombia Colombia
    #PorTodaColombia #PorTodaColombia
    Ciudad Guayana - Venezuela Ciudad Guayana - Venezuela
    Latinoamerica Latinoamerica
    Medellin, Colombia Medellin, Colombia
    Bogota Bogota
    Colombia Colombia
    Medellín, Colombia Medellin, Colombia
    Texas, USA Texas, USA
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Colombia Colombia
     
     
    Bogota Colombia  Bogota Colombia 
    Colombia / England Colombia / England
     
     
    Bucaramanga, Colombia. Bucaramanga, Colombia.
    Monteria  Monteria 
     
     
    Montería, Colombia Monteria, Colombia
    New york. EEUU New york. EEUU
     
     
    Bogota, Colombia Bogota, Colombia
     
     
    Medellin, Colombia Medellin, Colombia
    11.009303,-74.808855 11.009303,-74.808855
    Colombia Colombia
    Boyacá, Colombia Boyaca, Colombia
    Colombia Colombia
    Miami Miami
     
     
     
    Colombia - Antioquia Colombia - Antioquia
    Valledupar, Colombia Valledupar, Colombia
    Santa Marta, Colombia Santa Marta, Colombia
     
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Bogotá, D.C; Colombia. Bogota, D.C; Colombia.
    Bogota D.C Bogota D.C
     
    Atlanta Premio Nal de Paz 2008 Atlanta Premio Nal de Paz 2008
    Bogotá DC, Colombia  Bogota DC, Colombia 
     
    Colombia Colombia
    Colombia  Colombia 
    Bogotá, Colombia Bogota, Colombia
    Bogotá Bogota
    Colombia Colombia
    Cali, Valle del Cauca Cali, Valle del Cauca
    Medellín - Colombia Medellin - Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, Colombia Bogota, Colombia
    Barranquilla Barranquilla
    New York City New York City
    Ciudad del Vaticano Ciudad del Vaticano
    Vatican City Vatican City
     
     
    Vancouver, Canada Vancouver, Canada
    Valledupar, Colombia... Valledupar, Colombia...
    Mónaco Monaco
    Cali, Colombia Cali, Colombia
    Barranquilla, Colombia Barranquilla, Colombia
     
    Donde el honor me lo exija Donde el honor me lo exija
    Venezuela Venezuela
    San Salvador, El Salvador San Salvador, El Salvador
    Bogota, Colombia Bogota, Colombia
    New York, USA New York, USA
    Colombia Colombia
    Bogotá DC  Bogota DC 
     
    Colombia Colombia
    Bogota, Colombia Bogota, Colombia
    Colombia Colombia
    Colombia  Colombia 
    bogotá colombia bogota colombia
    Bogotá - Colombia Bogota - Colombia
    Ciudad Caótica Ciudad Caotica
     
    Valledupar, Cesar Valledupar, Cesar
     
    Bogotá / Cartagena - Colombia Bogota / Cartagena - Colombia
    Natagaima y Chicoral Natagaima y Chicoral
    Envigado Envigado
    Valledupar, Cesar, Colombia Valledupar, Cesar, Colombia
     
     
    Bogota - Roma - Genéve  Bogota - Roma - Geneve 
     
    Medellin, Colombia Medellin, Colombia
    Bogotá, D.C; Colombia Bogota, D.C; Colombia
    Bogotá, Colombia Bogota, Colombia
     
    Colombia Colombia
    Cuba Cuba
     
     
    Atlanta, Georgia, USA Atlanta, Georgia, USA
    Everywhere Everywhere
     
     
    Medellín, Colombia Medellin, Colombia
    América/America   America/America  
    Colombia Colombia
     
    Fata Morgana. Fata Morgana.
    Colombia Colombia
    Montería, Colombia. Monteria, Colombia.
    Ontario, Canada Ontario, Canada
    Isla de Margarita - Venezuela Isla de Margarita - Venezuela
    Caracas Caracas
    Desde el infinito y más allá Desde el infinito y mas alla
    En Algún Lugar del Mundo En Algun Lugar del Mundo
    Medellín, Colombia. Medellin, Colombia.
    Santa Marta, Magdalena Santa Marta, Magdalena
     
     
    De Amalfi Ant. pa' servirle!!! De Amalfi Ant. pa' servirle!!!
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Naples, Florida Naples, Florida
     
    Sogamoso, Boyacá, Colombia Sogamoso, Boyaca, Colombia
     
    Washington, DC Washington, DC
    Medellin - Antioquia Medellin - Antioquia
     
    INSTAGRAM @mariaconchita_a  INSTAGRAM @mariaconchita_a 
    Medellin Medellin
    San Francisco, CA San Francisco, CA
    Barranquilla, Colombia Barranquilla, Colombia
    Colombia Colombia
    Colombia Colombia
     
    VENEZUELA VENEZUELA
    Ibagué, Colombia Ibague, Colombia
    Sahagún - Córdoba - Colombia Sahagun - Cordoba - Colombia
     
    Medellín Medellin
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Mexicali Mexicali
     
    Cúcuta, Colombia Cucuta, Colombia
    United States & Germany United States & Germany
    Colombia Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Barranquilla, Colombia  Barranquilla, Colombia 
     
     
    Medellin, Colombia Medellin, Colombia
    Bogotá, Colombia Bogota, Colombia
     
    Ecuador Ecuador
    En la via En la via
    9:00 a 10:00 AM en Capital 710 9:00 a 10:00 AM en Capital 710
     
    Colombia Colombia
     
    Vzla, Col, Méx  Vzla, Col, Mex 
     
    Antioquia Colombia Antioquia Colombia
     
     
    Egipto Egipto
    Colombia 🇨🇴 Colombia 
    Miami - USA Miami - USA
    Colombia / Washington Colombia / Washington
    Barranquilla, Colombia Barranquilla, Colombia
    Los Angeles, California Los Angeles, California
    Miami, FL Miami, FL
    Medellin - Colombia Medellin - Colombia
     
    Venezuela Venezuela
    Argentina Argentina
     
     
    Colombia Colombia
    Colombia Colombia
    Salí y ahora no puedo entrar Sali y ahora no puedo entrar
    Bogotá, Colombia Bogota, Colombia
    Medellín, Antioquia Medellin, Antioquia
    Estados Unidos Estados Unidos
    Ecuador Ecuador
     
     
     
    Manizales, Colombia Manizales, Colombia
    Bogotá, D.C Bogota, D.C
    América Latina America Latina
    España Espana
    Montevideo, Uruguay Montevideo, Uruguay
    Medellin Medellin
    lejos de mis perros lejos de mis perros
    All over the world All over the world
    Washington, DC Washington, DC
     
    MEDELLIN MEDELLIN
    Colombia Colombia
    El Nacional, Los Cortijos El Nacional, Los Cortijos
    Bogotá COLOMBIA Bogota COLOMBIA
    Monterrey, Nuevo León, México Monterrey, Nuevo Leon, Mexico
    Bogotá, Colombia Bogota, Colombia
    URIBISTA  y Centro Democratico URIBISTA  y Centro Democratico
    ÜT: 34.022451,-84.259735 UT: 34.022451,-84.259735
     
    Bogotá- Colombia Bogota- Colombia
    Medellín Medellin
     Vengo del pasado: Macondo   Vengo del pasado: Macondo 
    España Espana
    Bucaramanga / Colombia Bucaramanga / Colombia
     
     
    Stanford, California Stanford, California
    Instagram: hassannassar Instagram: hassannassar
    Montería, Córdoba, Colombia Monteria, Cordoba, Colombia
    Rionegro - Antioquia Rionegro - Antioquia
    Atlanta, GA Atlanta, GA
    Washington, DC Washington, DC
    Colombia Colombia
    Venezuela Venezuela
    Bogota - Colombia Bogota - Colombia
    Venezuela Venezuela
    Venezuela Venezuela
    Neiva - Huila - Colombia Neiva - Huila - Colombia
    London London
    Colombia Colombia
    Colombia - Valledupar/Cesar Colombia - Valledupar/Cesar
    Colombia Colombia
    Zipaquirá, Colombia Zipaquira, Colombia
    Colombia Colombia
    Cali, Colombia Cali, Colombia
    Madrid Madrid
     
     
    Everywhere, worldwide! Everywhere, worldwide!
    ÜT: 10.211407,-64.648254 UT: 10.211407,-64.648254
    Santa Marta, Colombia Santa Marta, Colombia
    Colombia Colombia
     
    London London
     
    Bogotá - Colombia Bogota - Colombia
    Bogotá, Colombia Bogota, Colombia
    Barranquilla, Colombia Barranquilla, Colombia
    Medellín, Antioquia Medellin, Antioquia
    COLOMBIA COLOMBIA
    Bucaramanga, Santander Bucaramanga, Santander
     
    Colombia Colombia
     
    Lima Peru Lima Peru
    Bogotá D.C. Bogota D.C.
    MIAMI FL MIAMI FL
    Colombia Colombia
    Monteria, Cordoba. Monteria, Cordoba.
    Orgullosamente de Marinilla Orgullosamente de Marinilla
     
     
    Colombia Colombia
    Colombia Colombia
    Medellin, Colombia Medellin, Colombia
     
    Medellín, Colombia Medellin, Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotà Bogota
    Bogota, Colombia Bogota, Colombia
    Bogotá Bogota
     
    Cali-Colombia Cali-Colombia
    Edo. Vargas Edo. Vargas
    Panamá Panama
    REPUBLICA FEDERAL DE COLOMBIA REPUBLICA FEDERAL DE COLOMBIA
    www.laotraesquina.co www.laotraesquina.co
     
    Medellín, Colombia Medellin, Colombia
    Sincelejo - Sucre Sincelejo - Sucre
     
     
    601 Brickell Key Dr, Suite 103 601 Brickell Key Dr, Suite 103
    Mojón guindao, Sucre Mojon guindao, Sucre
    You'll find me at an airport. You'll find me at an airport.
    Here & there. Proud Canadian. Here & there. Proud Canadian.
    Bolivia Bolivia
    Valledupar, CO Valledupar, CO
     
    valledupar valledupar
    Colombia Colombia
    Colombia Colombia
    Bogotá Bogota
    Colombia Colombia
     
    Venezuela Venezuela
     
    Colombia Colombia
    Bogotá/New York Bogota/New York
    DC DC
    New York, NY New York, NY
     
    Caracas, Venezuela Caracas, Venezuela
     
    Venezuela Venezuela
    Venezuela Venezuela
     
    Bogotá D.C. Bogota D.C.
    Medellín, Colombia Medellin, Colombia
     
    México Mexico
     Mexico/Francia/USA  Mexico/Francia/USA
     
    En Toda Latinoamérica.  En Toda Latinoamerica. 
    Buenos Aires, Argentina Buenos Aires, Argentina
    Bogotá - Colombia Bogota - Colombia
    Bogota Colombia Bogota Colombia
    Boston, MA Boston, MA
     
     
     
    Continente Americano Continente Americano
     
    Washington D.C. Washington D.C.
    Cuentas claras, cuentas sanas. Cuentas claras, cuentas sanas.
    Bogota, Colombia Bogota, Colombia
    Bogotá, Colombia Bogota, Colombia
    monitoreo@presidencia.Colombia monitoreo@presidencia.Colombia
     
     Atlanta, Ga  Atlanta, Ga
    México Mexico
    Bogotá, Colombia Bogota, Colombia
    Bogotá Bogota
    Medellín, Colombia Medellin, Colombia
    La Calera, Colombia La Calera, Colombia
     
    ÜT: 4.624224,-74.069198 UT: 4.624224,-74.069198
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    colombia colombia
    Colombia Colombia
    Magdalena Medio. Sur del Cesar Magdalena Medio. Sur del Cesar
     
    Charleston, SC Charleston, SC
    Delivering your photos Delivering your photos
    Miami Miami
    New York City New York City
     
    Medellín, Colombia Medellin, Colombia
     
    Colombia Colombia
     
     
    Alemania - Colombia Alemania - Colombia
    Bruselas / Belgica Bruselas / Belgica
     
    Colombia Colombia
     
    En todas partes En todas partes
    Colombia Colombia
    London London
    Bogotá Bogota
    Medellín / Bogotá Medellin / Bogota
    London, UK London, UK
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
     
    Bogotá Bogota
    Washington, DC Washington, DC
    Bogotá, Colombia Bogota, Colombia
    Miami FL Miami FL
    Por ahí... Por ahi...
    Cambridge, MA US Cambridge, MA US
     
    Miami, FL Miami, FL
    Miami, FL Miami, FL
    Washington, DC Washington, DC
    AA, Avianca, LATAM, United, BA.... AA, Avianca, LATAM, United, BA....
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
     
     
     
    United States United States
    Rionegro. Antioquia Rionegro. Antioquia
    Bogotá Bogota
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
     
    Medellín, Antioquia Medellin, Antioquia
    Melbourne, Victoria Melbourne, Victoria
     
     
     
    ÜT: 10.301793,-66.828775 UT: 10.301793,-66.828775
    La distancia adecuada. La distancia adecuada.
    :) :)
    Arauca -Colombia Arauca -Colombia
     
    Colombia Colombia
    ÜT: 4.676608,-74.040679 UT: 4.676608,-74.040679
    Medellín Medellin
    Eterno verano Eterno verano
    Bogotá, Colombia Bogota, Colombia
    ÜT: 6.210789,-75.564233 UT: 6.210789,-75.564233
    COLOMBIA COLOMBIA
    Medellin - Colombia Medellin - Colombia
    Barranquilla, Colombia Barranquilla, Colombia
     
    Medellín Medellin
    Bogota,Colombia. Bogota,Colombia.
    Barranquilla Barranquilla
    Panama Panama
    Centro Democratico Centro Democratico
    Pereira, Risaralda, Colombia Pereira, Risaralda, Colombia
    Antioquia, Colombia Antioquia, Colombia
    Bogota, Colombia Bogota, Colombia
    Bogotá, Colombia Bogota, Colombia
    U.S. U.S.
    Bogotá, D.C., Col Bogota, D.C., Col
    Desaparecido Desaparecido
    Vereda San Carlos Vereda San Carlos
    PEREIRA, COLOMBIA, SUR AMERICA PEREIRA, COLOMBIA, SUR AMERICA
    Pasto Pasto
     
    Colombia Colombia
     
    Exterior Exterior
    Planet Earth Planet Earth
    Pereira, Risaralda. Pereira, Risaralda.
    Medellin Medellin
    ÜT: 4.601251,-74.063815 UT: 4.601251,-74.063815
    Colombia Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Planet Earth (Water) Planet Earth (Water)
    Colombia Colombia
    Colombia Colombia
    Bogotá - Colombia Bogota - Colombia
    ÜT: 10.496082,-66.853998 UT: 10.496082,-66.853998
    Colombia  & USA Colombia  & USA
     
    Colombia Colombia
    Colombia Colombia
    Medellín, Antioquia   Medellin, Antioquia  
    Bogotà - Colombia Bogota - Colombia
    Medellín Colombia Medellin Colombia
    Bogotá, Colombia. Bogota, Colombia.
    Colombia Colombia
    colombia colombia
    Oriente Antioqueño Oriente Antioqueno
    Bogota D.C. Bogota D.C.
    ÜT: 4.667453,-74.053682 UT: 4.667453,-74.053682
    California, USA California, USA
    Our World ☮ Our World 
     
    Bogotá D.C., Colombia Bogota D.C., Colombia
    Washington, DC USA Washington, DC USA
    RIOSUCIO CHOCO RIOSUCIO CHOCO
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    , costas y ríos de CO. , costas y rios de CO.
    La Red del Conocimiento La Red del Conocimiento
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
     
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Santander, Colombia Santander, Colombia
    Colombia Colombia
    Bogotá,Colombia Bogota,Colombia
     
     
     
    Worldwide Worldwide
    Santander, Colombia Santander, Colombia
     
    Bogotá, Colombia Bogota, Colombia
    Bogota, Colombia. Bogota, Colombia.
    ÜT: 3.530664,-76.381969 UT: 3.530664,-76.381969
    Colombia Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá / Cali (Col) Bogota / Cali (Col)
     
    Bogotá, D.C. Bogota, D.C.
    San Francisco, CA San Francisco, CA
     
    Medellín Medellin
     
    Antioquia Antioquia
    Bogotá, Colombia Bogota, Colombia
    Amsterdam baby Amsterdam baby
    Medellín Medellin
    San Andres Islas San Andres Islas
    Medellín-NYC Medellin-NYC
    Bogotá, Colombia Bogota, Colombia
    Venezuela Venezuela
    Bogotá Bogota
    Boston, Massachusetts Boston, Massachusetts
    Todos podemos cambiar el mundo Todos podemos cambiar el mundo
     
    Instagram: hassannassar Instagram: hassannassar
     
     
    We're Global! We're Global!
    Cali, Colombia Cali, Colombia
    Colombia Colombia
    ¡¡¡¡¡¡Antioqueños, papá!!!!!! !!!!!!Antioquenos, papa!!!!!!
    Medellín, Colombia Medellin, Colombia
    Cali - Colombia  Cali - Colombia 
    Colombia Colombia
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
     
    Bogota D.C. Bogota D.C.
     
    Colombia Colombia
    Nariño, Colombia Narino, Colombia
    Bogotá Bogota
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá Bogota
     
    Colombia Colombia
    Medellín-Colombia Medellin-Colombia
    Amalfi - antioquia  Amalfi - antioquia 
    Melbourne, Victoria Melbourne, Victoria
    MEDELLIN MEDELLIN
     
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Santiago de Cali Santiago de Cali
    Colombia Colombia
     
    ÜT: 4.676608,-74.040679 UT: 4.676608,-74.040679
    Bogotá, Colombia. Bogota, Colombia.
    Washington D.C. Washington D.C.
    Oxford, UK | Bogotá, Colombia Oxford, UK | Bogota, Colombia
     
    Medellín, Colombia Medellin, Colombia
    Medellín Medellin
     
     
    Stanford University Stanford University
    Colombia Colombia
    Miami, FL Miami, FL
     
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Colombia Colombia
     
    Medellín Medellin
     
    Colombia Colombia
    Colombia Colombia
    Chocó, Colombia Choco, Colombia
    Bogotá - Colombia Bogota - Colombia
    Bogotá D.C. Bogota D.C.
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Medellín, Colombia Medellin, Colombia
     
    Oriente Antioqueño Oriente Antioqueno
     
     
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Colombia Colombia
     
    Colombia Colombia
    Medellín Medellin
     
    Medellín Medellin
    Antioquia Antioquia
    Antioquia Antioquia
     
    Maringá-PR-Brasil Maringa-PR-Brasil
    Bogotá, Colombia Bogota, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Medellín, Antioquia, Colombia Medellin, Antioquia, Colombia
    Colombia Colombia
     
    Medellín, Antioquia, Colombia Medellin, Antioquia, Colombia
    Medellín - Colombia Medellin - Colombia
     
    Medellín Medellin
    Medellín, Colombia Medellin, Colombia
    Colombia  Colombia 
    Medellín / Carmen de Viboral Medellin / Carmen de Viboral
    Medellin Medellin
    Antioquia, Colombia Antioquia, Colombia
    Colombia Colombia
    Rionegro, Oriente Antioqueño. Rionegro, Oriente Antioqueno.
    El 3° Sector con el 4° Poder El 3deg Sector con el 4deg Poder
    Medellín, Colombia Medellin, Colombia
    Medellín - Colombia Medellin - Colombia
    Medellín y Twitterland  Medellin y Twitterland 
    Medellin, Colombia Medellin, Colombia
    Medellín, Colombia Medellin, Colombia
    Medellín - Colombia Medellin - Colombia
    Medellin, Colombia Medellin, Colombia
    Medellín, Colombia Medellin, Colombia
    Medellin, Colombia Medellin, Colombia
    Medellín, Antioquia Medellin, Antioquia
    Medellin / Colombia Medellin / Colombia
    DE COLOMBIA CON ORGULLO DE COLOMBIA CON ORGULLO
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Antioquia, Colombia Antioquia, Colombia
    Envigado Envigado
    Medellin, Antioquia Medellin, Antioquia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Antioquia, Colombia Antioquia, Colombia
    Antioquia Antioquia
    Medellín Medellin
     
     
    Medellín Medellin
    Santiago / Chile Santiago / Chile
    Medellín-Colombia Medellin-Colombia
    México Mexico
    España Espana
    Bogota, Colombia Bogota, Colombia
     
    Colombia - España Colombia - Espana
     
    Colombia Colombia
    Bogotá, D.C  Bogota, D.C 
    Colombia Colombia
    Bogotá Bogota
    Bogotá COLOMBIA Bogota COLOMBIA
    Andes, Antioquia Andes, Antioquia
     
    Antioquia Antioquia
    Medellín Medellin
    Urrao, Colombia Urrao, Colombia
    Medellín, Antioquia Medellin, Antioquia
    Cartagena+Barranquilla+aviones Cartagena+Barranquilla+aviones
    Medellín, Antioquia Medellin, Antioquia
    Medellín. Medellin.
    Medellín, Antioquia Medellin, Antioquia
    Medellín Medellin
    Colombia Colombia
    Washington, DC Washington, DC
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Cuentas claras, cuentas sanas. Cuentas claras, cuentas sanas.
    Colombia Colombia
    Armenia Armenia
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá Bogota
    Bogotá, Colombia Bogota, Colombia
    Bogotá Bogota
    Bogotá, DC, Colombia Bogota, DC, Colombia
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Colombia Colombia
    Bogotá Bogota
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Bogotá D.C. Bogota D.C.
     
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, Colombia Bogota, Colombia
    Miami, FL Miami, FL
    Ciudad de México - Medellín Ciudad de Mexico - Medellin
    Bogotá, Colombia Bogota, Colombia
     
    Colombia Colombia
    Medellín Medellin
    Colombia Colombia
    Bogotá Bogota
    Medellín, Colombia Medellin, Colombia
    Bogotá, Colombia Bogota, Colombia
    Medellín / Colombia Medellin / Colombia
    Medellín Medellin
    ÜT: 4.650541,-74.074043 UT: 4.650541,-74.074043
    Bogotá Bogota
    Colombia Colombia
    Medellín Medellin
    Medellín, Antioquia Medellin, Antioquia
    Medellín Medellin
    Bogotá D.C., Colombia Bogota D.C., Colombia
    Bogotá Bogota
    It’s Colombia, not Columbia It's Colombia, not Columbia
    Medellin Medellin
    De Medellín De Medellin
    Berkeley, CA Berkeley, CA
    Colombia Colombia
    Medellín Medellin
    ÜT: 6.212833,-75.561281 UT: 6.212833,-75.561281
    Colombia Colombia
    Medellín Medellin
    Miami Miami
    Medellín, Antioquia Medellin, Antioquia
    Colombia Colombia
     
    Graduate Center CUNY, New York Graduate Center CUNY, New York
    Bogotá - Colombia Bogota - Colombia
     
    bogota, colombia bogota, colombia
    Bogota- Colombia  Bogota- Colombia 
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Mi Ría, mi Mar, mi Océano... Mi Ria, mi Mar, mi Oceano...
     
    Antioquia, Colombia Antioquia, Colombia
     
    United States United States
     
    Colombia Colombia
    Santa Marta, Magdalena Santa Marta, Magdalena
    Colombia Colombia
    Santa Marta Santa Marta
    Bogotá - Ibagué Bogota - Ibague
    Washington, DC Washington, DC
    Washington D.C. Washington D.C.
    Washington, DC Washington, DC
    Cali, Colombia Cali, Colombia
    Ibagué, Colombia Ibague, Colombia
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Colombia Colombia
     
    @marchapatriota - @UP_Colombia @marchapatriota - @UP_Colombia
    La casa de ritmo La casa de ritmo
    Cauca, Colombia Cauca, Colombia
    Bogotá Bogota
    alepo alepo
    Bogota Bogota
    Bogotá (Colombia) Bogota (Colombia)
    Colombia Colombia
    International International
    Santander, Colombia Santander, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
     
    Nabi Saleh Nabi Saleh
    New York, USA New York, USA
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Pandemónium Pandemonium
    Bogotá, Colombia Bogota, Colombia
     
    WhatsApp: 3194151058 WhatsApp: 3194151058
    Bogotá, DC, Colombia Bogota, DC, Colombia
     
    Santander, Colombia Santander, Colombia
    Cúcuta, Colombia Cucuta, Colombia
     
    Colombia La Guajira Colombia La Guajira
    Colombia Colombia
     
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Honduras Honduras
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Armenia, Colombia Armenia, Colombia
     
    Capitales de América Latina Capitales de America Latina
    Washington, D.C. Washington, D.C.
    Bogotá - Colombia Bogota - Colombia
    Colombia Colombia
     
     
    Berlin, Germany Berlin, Germany
    Venezuela Venezuela
    Bogotá Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Chile Chile
     
    Medellín, Colombia Medellin, Colombia
    São Paulo & Buenos Aires Sao Paulo & Buenos Aires
     
    Americas Americas
    Guatemala Guatemala
     
    Colombia Colombia
     
    Yemen Yemen
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Oxford UK Oxford UK
    Colombia Colombia
    Bogota Bogota
     
     
    Bogotá, Colombia Bogota, Colombia
    En toda Colombia En toda Colombia
     
    BOGOTÁ/ y donde sea menester. BOGOTA/ y donde sea menester.
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Colombia Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Cartagena, Colombia Cartagena, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Bogotá, DC, Colombia Bogota, DC, Colombia
    Madrid Madrid
     
     
    Colombia Colombia
     
    Bogota Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Lima, Perú Lima, Peru
     
    Peru Peru
     
     
    La Bodega de Petro.  La Bodega de Petro. 
    Bogota Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    COLOMBIA COLOMBIA
     
     
    cundinamarca cundinamarca
    Bogotá Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Buenaventura, Colombia Buenaventura, Colombia
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Washington, DC Washington, DC
     
    Barranquilla, Colombia Barranquilla, Colombia
    Medellín Medellin
    Sao Paulo, Brasil Sao Paulo, Brasil
    Colombia Colombia
    London, England London, England
    México, DF Mexico, DF
     
    New York, NY New York, NY
     
    Waterloo, London Waterloo, London
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Madrid Madrid
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
     
     
    Manizales - Bogotá Manizales - Bogota
    Bogotá D.C. Bogota D.C.
    De la estrella Regulus αLeonis De la estrella Regulus aLeonis
    Bogotá, Colombia Bogota, Colombia
     
     
    Castille-La Mancha, Spain Castille-La Mancha, Spain
    🔔Activa las notificaciones🔔 Activa las notificaciones
    Irak +9647510693481 Irak +9647510693481
     
     
    Ecuador Ecuador
    Putumayo, Colombia Putumayo, Colombia
    Quito, Ecuador Quito, Ecuador
     
    Paraguay Paraguay
    Santiago, Chile Santiago, Chile
    Bogota  Bogota 
     
    Colombia Colombia
    Distrito Federal, México Distrito Federal, Mexico
     
    Bogotá,Colombia Bogota,Colombia
    Santiago, Chile Santiago, Chile
    Bogotá Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Caracas, Venezuela Caracas, Venezuela
    Bogotá, Colombia. Bogota, Colombia.
    Berlin, Germany Berlin, Germany
    Colombia Colombia
    Colombia Colombia
    Periodista, editora. Colombia  Periodista, editora. Colombia 
    colombia colombia
     
    Colombia Colombia
    Canada Canada
    Bogota  Bogota 
    Bogotá, Colombia Bogota, Colombia
     
    Bogotá, Colombia Bogota, Colombia
    Medellin Antioquia Colombia Medellin Antioquia Colombia
    Americas Americas
    Lima Metropolitana, Perú Lima Metropolitana, Peru
    Venezuela Venezuela
    Colombia Colombia
     
    Carrera 32A No. 26A - 10 Carrera 32A No. 26A - 10
    Colombia Colombia
    El Salvador El Salvador
    Cali, Colombia Cali, Colombia
    Santa Marta, DTCH Santa Marta, DTCH
     
     
    Popayan Popayan
     
     
    Ecuador Ecuador
    Manzanares el Real, España Manzanares el Real, Espana
    Chile Chile
    Bogota Bogota
    Bogotá D, C. Bogota D, C.
    Bucaramanga, Santander Bucaramanga, Santander
    Zipaquirá Zipaquira
    colombia colombia
    Barranquilla, Colombia Barranquilla, Colombia
     
    prensapaisa@hotmail.com prensapaisa@hotmail.com
    México Mexico
    Beirut, Líbano Beirut, Libano
    Medellin Antioquia Medellin Antioquia
    Bogotá Bogota
    Medellín, Barrio Triste. Medellin, Barrio Triste.
    Colombia Colombia
    London, UK London, UK
    Savannah, GA in 2018 Savannah, GA in 2018
    Bogota, Colombia Bogota, Colombia
     
    Planeta Tierra Planeta Tierra
    Villa de Antón Hero de Cepeda Villa de Anton Hero de Cepeda
    Colombia Colombia
    Colombia Colombia
    Las Américas Las Americas
     
    Norte de Santander, Colombia Norte de Santander, Colombia
    colombia colombia
     
    Bogotá, Colombia Bogota, Colombia
     
    Bogotá - Barranquilla Bogota - Barranquilla
    Bogotá, Colombia Bogota, Colombia
    Peru Peru
    Roma Roma
    Los Angeles, CA Los Angeles, CA
    New York, NY New York, NY
    Santander, Colombia Santander, Colombia
     
    México Mexico
    Montería - Colombia Monteria - Colombia
    Tolima, Colombia Tolima, Colombia
    Valledupar, Colombia Valledupar, Colombia
    La Habana, Cuba La Habana, Cuba
    Barrancabermeja Barrancabermeja
    Bogota, Colombia. Bogota, Colombia.
    Albacete, España Albacete, Espana
    Bogotá Bogota
    Moscú, Rusia Moscu, Rusia
     
    Bogotá Bogota
    Barranquilla - Santa Marta  Barranquilla - Santa Marta 
    Colombia Colombia
     
     
    Los Angeles, CA Los Angeles, CA
    Bogotá Bogota
    Bogota D.C Bogota D.C
    Montañas y ciudades - Colombia Montanas y ciudades - Colombia
    Bogotá Bogota
    Metro es para Ciudad Mosquera Metro es para Ciudad Mosquera
    Toronto, Canada Toronto, Canada
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Geneva, Switzerland Geneva, Switzerland
    Bogotá Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Valledupar Valledupar
     
    México, DF. Mexico, DF.
    Santiago de Chile Santiago de Chile
     
    Colombia Colombia
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Colombia Colombia
    São Paulo Sao Paulo
    Colombia  Colombia 
     
    América America
    Grecia y alrededores. Grecia y alrededores.
    Bogotá, Colombia Bogota, Colombia
     
     
    Moscú, Rusia Moscu, Rusia
    Buenos Aires Buenos Aires
    Colombia Colombia
    Bolivia Bolivia
    Bogota, Colombia. Bogota, Colombia.
    San Bruno, CA San Bruno, CA
     
     
    Managua, Nicaragua. Managua, Nicaragua.
    Venezuela Venezuela
     
    Cambridge, MA Cambridge, MA
    New York City New York City
     
    Ecuador Ecuador
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    北京, 中华人民共和国 Bei Jing , Zhong Hua Ren Min Gong He Guo 
     
     
    anarquismoenpdf@gmail.com anarquismoenpdf@gmail.com
     
     
    Bogotá, Colombia Bogota, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Colombia Colombia
    Washington DC Washington DC
    Colombia Colombia
    Bogota - Colombia Bogota - Colombia
    Venezuela Venezuela
     
    Bogotá, Colombia Bogota, Colombia
    Buenos Aires. Argentina Buenos Aires. Argentina
    Bogotá - Colombia Bogota - Colombia
    Brasil Brasil
    Bogota Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá Bogota
     
     
    Albacete, España Albacete, Espana
    Bogotá Bogota
    Colombia Colombia
    Bogotá D.C. Bogota D.C.
     
    Rio de Janeiro Rio de Janeiro
    Bogotá Bogota
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Brasil Brasil
    Uruguay Uruguay
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    France France
    Envigado Envigado
    Bogota - Colombia Bogota - Colombia
    Latinoamérica Latinoamerica
    BRA, CHN, IND, MEX, TKY, USA BRA, CHN, IND, MEX, TKY, USA
     
    Valle del Cauca, Colombia Valle del Cauca, Colombia
    Colombia Colombia
    Nicaragua Nicaragua
    Perú Peru
    Cusco/Lima - Perú Cusco/Lima - Peru
     
    Brazil Brazil
    São Paulo Sao Paulo
    São Paulo, Brazil Sao Paulo, Brazil
    Brasil Brasil
     
    Miami , Florida Miami , Florida
     
    Strasbourg / Brussels Strasbourg / Brussels
    El Salvador El Salvador
    Colombia Colombia
    New York, NY  New York, NY 
    Ciudad Bolívar-Bogotá-Colombia Ciudad Bolivar-Bogota-Colombia
    Buenos Aires, Argentina Buenos Aires, Argentina
     
    España Espana
     
    Morelos Morelos
    New York, NY New York, NY
    Colombia, Latinoamérica Colombia, Latinoamerica
    #ApoyoMutuo #ApoyoMutuo
    Colombia Colombia
     
    Bogotá, Colombia Bogota, Colombia
     
    Bogotá Bogota
    Bogota, COLOMBIA Bogota, COLOMBIA
    Estrasburgo, Francia Estrasburgo, Francia
     
    Bogotá D.C. Bogota D.C.
    Colombia Colombia
    Colombia Colombia
     
    Dresden, Sachsen Dresden, Sachsen
     
    Guerrero Guerrero
     
    Bogota, Colombia Bogota, Colombia
    Colombia - Suramérica Colombia - Suramerica
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Colombia Colombia
     
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
     
    NARIÑO COLOMBIA NARINO COLOMBIA
    Amazonia colombiana Amazonia colombiana
    Bogotá, Colombia Bogota, Colombia
     
    Cali, Colombia Cali, Colombia
    Bogotá, Colombia Bogota, Colombia
    MEDELLIN MEDELLIN
     
    France France
    Bogotá - Colombia Bogota - Colombia
     
    Colombia Colombia
     
    Bogotá Bogota
    Bogotá D.C Bogota D.C
    Bogota Bogota
    Bogota D.C Bogota D.C
    . .
    Madrid Madrid
    Bogotá, Colombia Bogota, Colombia
     
     
    Worldwide Cities Worldwide Cities
    Caminando por ahí! Caminando por ahi!
    www.facebook.com/tropamarxista www.facebook.com/tropamarxista
    Bogotá Bogota
     
    Opiniones personales Opiniones personales
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá Bogota
    Toulouse Toulouse
     
     
     
    Bogotá Bogota
    Río de Janeiro / Buenos Aires Rio de Janeiro / Buenos Aires
    Uruguay Uruguay
    Buenos Aires, Argentina Buenos Aires, Argentina
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Colombia Colombia
     
    Bogotá D.C. Bogota D.C.
    France / Monaco France / Monaco
     
     
    Medellín, Colombia Medellin, Colombia
    Bogotá Bogota
    Cúcuta. Cucuta.
    Bogota Bogota
    Bogotá, Colombia Bogota, Colombia
    Worldwide Worldwide
    Colombia Colombia
     
    Dystopia Dystopia
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogota Bogota
    Guatemala Guatemala
    Colombia Colombia
    Bogotá Colombia  Bogota Colombia 
    FI (Joensuu) / COL (Bogotá)  FI (Joensuu) / COL (Bogota) 
    Lejos de los indios Lejos de los indios
    Bogotá Bogota
    Argentina Argentina
    Bogotá Bogota
     
    Colombia Colombia
     
    Bogotá, Colombia Bogota, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    email: wayuuaraurayu@gmail.com email: wayuuaraurayu@gmail.com
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Madrid Madrid
     
    Bogotá Bogota
    ROMA Año 2771 Ab Vrbe Condita ROMA Ano 2771 Ab Vrbe Condita
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
     
    International International
    Cali, Colombia Cali, Colombia
    Boston, Massachusetts Boston, Massachusetts
    Bonn, Allemagne Bonn, Allemagne
    Por el mundo ✈ Por el mundo 
     
    Bonn, Alemania Bonn, Alemania
     
     
    Uruguay Uruguay
    Colombia Colombia
    Chilam Balam, Niuyol, Ventosa Chilam Balam, Niuyol, Ventosa
    América Latina America Latina
    UK UK
    Bogotá, Colombia Bogota, Colombia
    Vermont/DC Vermont/DC
    Cizre  Cizre 
     
    London, England London, England
    Medellín-Colombia Medellin-Colombia
    France France
    Bogotá, Villavicencio y 22 mun Bogota, Villavicencio y 22 mun
    Colombia Colombia
    Colombia Colombia
    Rolo, En medeshin Rolo, En medeshin
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
     
    COLOMBIA COLOMBIA
    La Guajira La Guajira
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Hawaii, USA Hawaii, USA
    Colombia Colombia
    Buenos Aires, Argentina Buenos Aires, Argentina
     
    Bogotá Bogota
     
    Airplane Airplane
    Bogotá Bogota
    Bogotá, Colombia Bogota, Colombia
     
    Las Piedras. Uruguay  Las Piedras. Uruguay 
    Bogotá Colombia Bogota Colombia
    Bogotá, Colombia Bogota, Colombia
    Pies en Barcelona Pies en Barcelona
     
    yanismanzano@hotmail.com yanismanzano@hotmail.com
    BOGOTÁ BOGOTA
    Athens, Greece Athens, Greece
    Colombia Colombia
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    bogota bogota
    Bogotá, Colombia Bogota, Colombia
    Washington, DC Washington, DC
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá Bogota
    Bogotá, Colombia Bogota, Colombia
    Vatican City Vatican City
    Colombia  Colombia 
    Colombia Colombia
    London, England London, England
     
    New Jersey, USA / Colombia New Jersey, USA / Colombia
     
     
    Bogotá, Colombia Bogota, Colombia
    Paris  Paris 
    Brooklyn, NY Brooklyn, NY
     
    France France
    Madrid Madrid
    Greece Greece
    NYS NYS
    France France
    Chía, Colombia Chia, Colombia
    Bogotá, Humana Bogota, Humana
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Bogotá Bogota
    Bogotá Colombia los Andes Bogota Colombia los Andes
     
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá Bogota
     
    Colombia Colombia
    Santa Marta, Colombia. Santa Marta, Colombia.
    BERLİN/ DEUTSCHLAND  BERLIN/ DEUTSCHLAND 
    Paris, France Paris, France
    En la olla En la olla
     
    Bogotá, D.C. Bogota, D.C.
    Colombia Colombia
    Uruguay Uruguay
    Uruguay Uruguay
    Bogotá, Colombia Bogota, Colombia
    Calle 10 # 3 - 61 Calle 10 # 3 - 61
     
     
     
     
    Madrid Madrid
    Barcelona Barcelona
    Bogotá. Bogota.
     
     
    Bogotá, Colombia Bogota, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    COLOMBIA COLOMBIA
    Bogotá D.C. Colombia Bogota D.C. Colombia
    Moscow Moscow
     
    Bogotá D.C. Bogota D.C.
    Bogotá, Colombia Bogota, Colombia
    Oxford, UK | Bogotá, Colombia Oxford, UK | Bogota, Colombia
    Bogotá D.C. Bogota D.C.
     
    Bogotá, Colombia Bogota, Colombia
     
    México y Latinoamérica Mexico y Latinoamerica
    Keep Reining Keep Reining
    Bogotá - Colombia Bogota - Colombia
     
     
     
     
     
     
    Clase Media Clase Media
    Bogotá Bogota
    Bogota Bogota
     
     
    Bogotá Bogota
    Washington, DC Washington, DC
     
    Bogotá  Bogota 
    Zuccotti Park, NYC Zuccotti Park, NYC
    New York City New York City
    CHI, DC, worldwide walkable CHI, DC, worldwide walkable
    Global Global
     
    Philadelphia, PA Philadelphia, PA
     
    New York, NY - Washington, DC New York, NY - Washington, DC
    Washington, DC Washington, DC
    Global Global
    New York and London New York and London
    London London
    London, England London, England
    London London
    New York New York
    Madrid, Comunidad de Madrid Madrid, Comunidad de Madrid
    #PuertoLaROCK #PuertoLaROCK
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bacata Bacata
     
    Bogotá, Colombia Bogota, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, Colombia Bogota, Colombia
    Bacata Bacata
    Bilbao Bilbao
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bacata Bacata
    Bacata Bacata
    Bogotá, Colombia Bogota, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, D.C. Bogota, D.C.
    Bacata Bacata
    Geneva, Switzerland Geneva, Switzerland
    Nottinghamshire, UK Nottinghamshire, UK
    Oświęcim, Polska Oswiecim, Polska
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Fontibón Fontibon
    Geneva, Switzerland  Geneva, Switzerland 
    Italia(Milano) EcuadorMiPais Italia(Milano) EcuadorMiPais
    BOGOTA D.C. BOGOTA D.C.
    Europe Europe
    Colombia Colombia
    Ciudad de México - Medellín Ciudad de Mexico - Medellin
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Paris, France Paris, France
    Faluya Faluya
    www.locoscomunistas.org www.locoscomunistas.org
    Paris, Ile-de-France Paris, Ile-de-France
     
    Asunción, Paraguay Asuncion, Paraguay
    México Mexico
    Learn english ! Learn english !
    Bogota, Colombia Bogota, Colombia
    Dersîm Dersim
     
    Bogotá, Colombia Bogota, Colombia
    Bogotá Bogota
    New York City New York City
     
    221 Baker Street Apt. B 221 Baker Street Apt. B
    Bogotá, Colombia Bogota, Colombia
     
    Caracas, Venezuela Caracas, Venezuela
    Bogotá, Colombia Bogota, Colombia
     
     
    Av Calle 26 No. 57 – 41 Av Calle 26 No. 57 - 41
    Bogotá, Colombia Bogota, Colombia
    L'Amunt  L'Amunt 
    St. Louis County, MO St. Louis County, MO
     
    Bogotá Bogota
    La Serena, Chile La Serena, Chile
    Bogota, Colombia Bogota, Colombia
     
    Bogotá Bogota
     
    Barcelona, Catalunya Barcelona, Catalunya
     
    Madrid Madrid
     
    Bogotá D.C. Bogota D.C.
    New York, USA New York, USA
    Peru Peru
    عائشة `y'sh@
    Bogotá Bogota
    Colombia Colombia
    Bogota, Colombia Bogota, Colombia
    Brasília / Brasil Brasilia / Brasil
    ¿ayuda? soporte@moovitapp.com ?ayuda? soporte@moovitapp.com
    حزب الاتحاد الديمقراطي Hzb ltHd ldymqrTy
    Al-Qamishli, Rojava, Northern Syria Al-Qamishli, Rojava, Northern Syria
     
    Medio Oriente Medio Oriente
    London, Tottenham London, Tottenham
    Catalonia Catalonia
    New York, NY New York, NY
     
    Colombia Colombia
    Worldwide Worldwide
     
     
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Bogotá D.C. Bogota D.C.
    Venezuela  Venezuela 
    Bogotá, Colombia Bogota, Colombia
    Bogotá, Colombia Bogota, Colombia
     
    Cereté, Colombia Cerete, Colombia
    Bogotá Bogota
     
    Colombia Colombia
     
     
     
    Bogotá Bogota
    Colombia Colombia
    Bogotá Bogota
     
    Cali, Colombia Cali, Colombia
    Mis opiniones son personales Mis opiniones son personales
    Colombia Colombia
    CDMX CDMX
    Bogotá, Colombia Bogota, Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá Bogota
    Estado de Palestina Estado de Palestina
    Venezuela Venezuela
     
    Deir Yassin, Palestine Deir Yassin, Palestine
    Madrid Madrid
    Beirut Beirut
     
     
     
     
     
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, Colombia Bogota, Colombia
    Moscú, Rusia Moscu, Rusia
    Bogota, Colombia Bogota, Colombia
    Facebook: http://ow.ly/ueEX9 Facebook: http://ow.ly/ueEX9
    Bogota Distrito Capital Bogota Distrito Capital
    Colombia Colombia
    Moniquira Moniquira
    Dig 30 # 14-49 Bogotá, D.C. Dig 30 # 14-49 Bogota, D.C.
    Buenos Aires Buenos Aires
    Bogotá, Colombia Bogota, Colombia
    República de Panamá Republica de Panama
    A km de la perfección A km de la perfeccion
    Bogotá D.C. Bogota D.C.
    en mi amada ciudad bolivar en mi amada ciudad bolivar
    Cali Cali
    Colombia Colombia
    Chia Cundinamarca Chia Cundinamarca
    Cali - Colombia Cali - Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá Bogota
    Colombia Colombia
    Tunja-Boyacá Tunja-Boyaca
    Colombia Colombia
    Bogota y Medellin -Colombia- Bogota y Medellin -Colombia-
     
     
    Bogotá - Colombia Bogota - Colombia
    Soacha, Colombia Soacha, Colombia
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Cucutilla, Colombia Cucutilla, Colombia
    Bogotá colombia Bogota colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Bogotá Bogota
     
     
    Bogotá, Colombia Bogota, Colombia
    Bogotá Bogota
    Catatumbo, Norte de Santander Catatumbo, Norte de Santander
    Colombia Colombia
    Bogotá - Colombia Bogota - Colombia
     
     
    Colombia Colombia
    Bogotá Bogota
    Bogotá Bogota
    Bogotá Bogota
    Bogota Bogota
    Barranquilla - Colombia Barranquilla - Colombia
     
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Long beach, ca Long beach, ca
    San José, Costa Rica San Jose, Costa Rica
    Panamá Panama
    Medellín( Colombia) Medellin( Colombia)
    Colombia Colombia
    Florida Florida
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotà Bogota
    Bogotá Bogota
    Colombia Colombia
    Risaralda, Colombia Risaralda, Colombia
    Citas de Grandes Pensadores Citas de Grandes Pensadores
     
    Colombia Colombia
    Bogotá-Colombia Bogota-Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Actriz / Colombia   Actriz / Colombia  
    Bogota Bogota
     Perla de America  Perla de America
     
    Bogotá-Colombia Bogota-Colombia
     
    Bogotá - Colombia Bogota - Colombia
     
     
     
    St Louis, MO St Louis, MO
    Colombia Colombia
    Colombia Colombia
    Bogotá Bogota
    Colombia Colombia
    Los Angeles, CA Los Angeles, CA
    World World
    Bogota. Col Bogota. Col
    Barranquilla, Colombia Barranquilla, Colombia
    London London
     
    Bogota, Colombia Bogota, Colombia
    Bogotá Bogota
    Bogotá D.C - Colombia Bogota D.C - Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá, Colombia Bogota, Colombia
     
     
    Síguenos en @CIMPI2014 Siguenos en @CIMPI2014
    En el pez globo En el pez globo
    Bogotá Bogota
    Universidad de los Andes Universidad de los Andes
    Medellín, Colombia Medellin, Colombia
    TUNJA BOYACA TUNJA BOYACA
    New York, USA New York, USA
    Reston, VA Reston, VA
     
    Colombia Colombia
     
    New York, NY New York, NY
    Paris - France Paris - France
     
    BOGOTA BOGOTA
     
    Bogotá- Colombia Bogota- Colombia
    Paris, France Paris, France
    Colombia Colombia
    Bogota Bogota
    Bogotá D.C. Bogota D.C.
    Colombia Rural Colombia Rural
    Bogotá - Colombia Bogota - Colombia
    Ciudad del Vaticano Ciudad del Vaticano
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, D.C. Colombia. Bogota, D.C. Colombia.
    Bogotá, Colombia Bogota, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
     
    El Mundo El Mundo
     
    Bogotá Colombia. Bogota Colombia.
    Bogotá - Colombia Bogota - Colombia
    Bogotá D.C. Bogota D.C.
    Colombia Colombia
    Bogotá Bogota
     
    Latin America Latin America
    Colombia Colombia
     
    Bogotá D.C. Bogota D.C.
     
     
     
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    International International
    Colombia- Teléfono (1) 5187000 cgr@contraloria.gov.co Colombia- Telefono (1) 5187000 cgr@contraloria.gov.co
     
    Bogotá.Colombia Bogota.Colombia
    Colombia Colombia
    Bta Bta
     
     
    Colombia Colombia
     
    Santiago, Chile Santiago, Chile
     
    México Mexico
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogota D.C. Bogota D.C.
    por todas partes por todas partes
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá Bogota
    Bogotá Bogota
    Bogotá, Colombia Bogota, Colombia
     
     
    Colombia Colombia
    Bogotá, D. C. Bogota, D. C.
    Chía. Chia.
    Colombia Colombia
    Colombia Colombia
    Bogotá Bogota
    Bogota.DC Bogota.DC
     
    Bogotá, Colombia Bogota, Colombia
    Santander de Quilichao Santander de Quilichao
    BOGOTA BOGOTA
    Santa Marta- Colombia Santa Marta- Colombia
    Colombia Colombia
     
    Bogota Colombia Bogota Colombia
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá-Colombia Bogota-Colombia
    Bogotá, Colombia Bogota, Colombia
    Andes, Colombia Andes, Colombia
     
    Bogotá Bogota
    BOGOTA BOGOTA
    Bogotá - Colombia Bogota - Colombia
    Venezuela Venezuela
    Bogotá, Colombia Bogota, Colombia
    Venezuela Venezuela
    Bucaramanga, Colombia Bucaramanga, Colombia
    Caracas Caracas
    Bogotá Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá Colombia Bogota Colombia
    Venezuela Venezuela
    Donde esté la noticia Donde este la noticia
     
    Venezuela Venezuela
    Caracas, Venezuela Caracas, Venezuela
    Bogota Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, Colombia Bogota, Colombia
    Paris et Grand Quevilly Paris et Grand Quevilly
    Medellín, Colombia Medellin, Colombia
    Medellín. Medellin.
     
     
    Colombia Colombia
    Bogotá Bogota
     
     
    !ogota Colombia !ogota Colombia
    Bogotá - Colombia Bogota - Colombia
    Colombia Colombia
    Bogota, Colombia Bogota, Colombia
    Bogotá - Colombia Bogota - Colombia
     
    Bogotá, D.C. Bogota, D.C.
    Washington D.C. Washington D.C.
     
    bogotá colombia bogota colombia
    BOGOTA BOGOTA
    Bogota Bogota
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Bogotá, D.C Bogota, D.C
    Bogota, Colombia Bogota, Colombia
     
     
    Bogota Bogota
    SANTIAGO DE CALI SANTIAGO DE CALI
     
    Bogotá, Colombia Bogota, Colombia
    Bogotá, Colombia Bogota, Colombia
    Berkeley, CA Berkeley, CA
    Bogotá, Colombia Bogota, Colombia
     
     
     
    Bogotá, Colombia Bogota, Colombia
     
    Bogotá, Colombia Bogota, Colombia
    Bogotá Bogota
    Los Angeles, CA Los Angeles, CA
    Bogotá Bogota
     
     
     
     
    Ateo © Justice for Duncan Ateo (c) Justice for Duncan
    Bogota de todos Bogota de todos
    Països Catalans Paisos Catalans
    Panama City Panama City
    Bogotá Bogota
    Bucaramanga Bucaramanga
    Colombia Colombia
    Santa Marta, Colombia Santa Marta, Colombia
     
    United States United States
    New York New York
     
    Buenos Aires, Argentina Buenos Aires, Argentina
    Bogotá, Colombia Bogota, Colombia
    Bogotá Bogota
    Bogotá Bogota
    Europe, N.America, LATAM, Asia Europe, N.America, LATAM, Asia
    Paris, France Paris, France
    #CongresoCorrupto #CongresoCorrupto
    ÜT: 6.210789,-75.564233 UT: 6.210789,-75.564233
    Bogota D.C., Colombia Bogota D.C., Colombia
     
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    ÜT: 10.494456,-66.826093 UT: 10.494456,-66.826093
    Bogotá Colombia Bogota Colombia
    Cali, Colombia Cali, Colombia
    Bogotá Bogota
    Colombia-Bogota Colombia-Bogota
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Colombia Colombia
    Bogotá Bogota
    Bogotá Bogota
     
    Bogotá, DC. Bogota, DC.
    Bogotá Bogota
    Bogotá Bogota
    Bogotá D.C. Bogota D.C.
     
     
    Bogota Bogota
     
     
    Colombia Colombia
    Bogotá Bogota
    COLOMBIA COLOMBIA
     
    Nariño, Colombia Narino, Colombia
     
     
    Bogotá D.C. Bogota D.C.
    Bogotá Bogota
    Colombia Colombia
    ☂ Bogotá ☂   Bogota  
    Barcelona Barcelona
    Colombia Colombia
    Bogota D.C Bogota D.C
    colombia colombia
    Periodista. Tuits personales.  Periodista. Tuits personales. 
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Cartagena de Indias Cartagena de Indias
    Colombia Colombia
     
     
    Cali, Colombia Cali, Colombia
    Bogotá Bogota
     
    Bogotá Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, Colombia Bogota, Colombia
     
    Bogota. colombia Bogota. colombia
    Armenia, Quindio. Armenia, Quindio.
    Bogotá- Colombia Bogota- Colombia
     
    Colombia Colombia
    villavicencio  Meta villavicencio  Meta
    Bogotá Bogota
    Colombia Colombia
     
    Bogotá, Colombia Bogota, Colombia
     
    Bogota Colombia Bogota Colombia
    Colombia Colombia
    Bogotá/Colombia Bogota/Colombia
     
     
    Colombia Colombia
     
    Montreal-Quebec-Canada Montreal-Quebec-Canada
    Santiago de Compostela, España Santiago de Compostela, Espana
    armenia armenia
    Colombia Colombia
    Bogotá Bogota
    Argentina Argentina
    Madrid Madrid
    Bogotá Bogota
    Bogota Bogota
    Jayapura Jayapura
    Bogotá D.C Bogota D.C
    Colombia  Colombia 
     
    Asuncion Asuncion
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Bogota Bogota
    on iOS, Android, Kindle on iOS, Android, Kindle
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Ibagué, Colombia Ibague, Colombia
     
     
    SantCugat|Madrid|Latam SantCugat|Madrid|Latam
    Cota, Cundinamarca Cota, Cundinamarca
     
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Spain Spain
    colombia  armenia  quindio colombia  armenia  quindio
    Colombia, Bogotá Colombia, Bogota
     
     
    Bogotá Bogota
    Bogotá, Colombia Bogota, Colombia
    Bogotá, Colombia Bogota, Colombia
     
    Bogotá-Colombia Bogota-Colombia
    Barranquilla, Colombia Barranquilla, Colombia
    Bogotà Bogota
    Bogotá, Colombia Bogota, Colombia
    Bogotá, D.C. Bogota, D.C.
    Venezuela Venezuela
    SNSM SNSM
    Bogotá Bogota
    Bogotá Bogota
     
    BOGOTÁ BOGOTA
     
    Cali Cali
    Bogota Bogota
    Bogotá Bogota
    Bogotá Bogota
     
    Bogota y el mundo Bogota y el mundo
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Ciudad de México Ciudad de Mexico
    México Mexico
    Rio de Janeiro Rio de Janeiro
    COLOMBIA COLOMBIA
    Bogota Bogota
    Bogotá Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Medellín Medellin
     
    Bogota.Colombia Bogota.Colombia
    Bogota - Colombia Bogota - Colombia
    Colombia Colombia
    Bogotá D.C. Bogota D.C.
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Bogotá, Colombia Bogota, Colombia
    Bogotá  Bogota 
    Madrid, Spain Madrid, Spain
    Bogotá Bogota
    Bogotá, Colombia. Bogota, Colombia.
    Colombia Colombia
    Bogotá Bogota
    Bogota Bogota
    tumaco colombia tumaco colombia
    Lima, Peru Lima, Peru
     
    Panamá Panama
    Colombia, Sur América Colombia, Sur America
    Bogotá Bogota
    Bogotá Bogota
    Bogota, CO. Bogota, CO.
    Colombia Colombia
     
    ⓚilla town killa town
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Medellín, Colombia Medellin, Colombia
     
    Bogotá - Colombia Bogota - Colombia
    Bogotá Bogota
    Bogotá D.C. Bogota D.C.
    Colombia Colombia
     
    COLOMBIA- BOGOTA COLOMBIA- BOGOTA
    Barcelona Barcelona
    Bogota-Colombia Bogota-Colombia
     
    Bogotá, Colombia Bogota, Colombia
    Sogamoso, Colombia Sogamoso, Colombia
    ocaña ocana
    Bogota, Colombia Bogota, Colombia
    Bogota, Colombia Bogota, Colombia
    Bogotá Bogota
     
    Bogotá D.C. Bogota D.C.
    Bogotá, Colombia Bogota, Colombia
    Bogotá, Colombia Bogota, Colombia
     
    BOGOTA BOGOTA
    Bogotá Bogota
    London & New York London & New York
    Bogotá, Colombia Bogota, Colombia
    Bogotá  Bogota 
    Bogotá D.C Bogota D.C
     
    Las Condes, Chile Las Condes, Chile
    Bogotá, Colombia Bogota, Colombia
     
     
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá D.C. Bogota D.C.
    San Jacinto, Colombia San Jacinto, Colombia
    Colombia Colombia
     
    Colombia Colombia
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
    Colombia Colombia
    Colombia Colombia
    Bogotá (Colombia) Bogota (Colombia)
    Venezuela Venezuela
    Bogotá Bogota
    Caribe Colombiano Caribe Colombiano
     
     
    Colombia • Karibá Ati Seynekun Colombia * Kariba Ati Seynekun
    Yumbo Yumbo
    Bogotá D.C. Bogota D.C.
    Atlántico Atlantico
    Colombia Colombia
     
     
     
     
    Barranquilla, Colombia Barranquilla, Colombia
    Marinilla, Antioquia Marinilla, Antioquia
    BOGOTA BOGOTA
    Bogotá DC, COLOMBIA Bogota DC, COLOMBIA
     
    Bogota - Colombia Bogota - Colombia
    Colombia  Colombia 
     
     
    Bogotá Bogota
    Cali-Colombia Cali-Colombia
    Bogota/colombia Bogota/colombia
    República medieval de Colombia Republica medieval de Colombia
     
    Facatativá Facatativa
    Colombia Colombia
     
    Bogotá, Colombia Bogota, Colombia
    Bogota, Colombia Bogota, Colombia
    Bogotá, DC, Colombia Bogota, DC, Colombia
    Antioquia, Colombia Antioquia, Colombia
    Ninguna Ninguna
    colombia colombia
     
    Bogota, Colombia Bogota, Colombia
    Pamplona Pamplona
    santa marta colombia santa marta colombia
    Colombia Colombia
    Tame Tame
     
    VALLEDUPAR VALLEDUPAR
     
    Bogota Bogota
    Bucaramanga Bucaramanga
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
     
     
     
     
    Bogota  Bogota 
    Colombia Colombia
    Bogota, Colombia Bogota, Colombia
     
     
    Bogotá Bogota
     
    bogota- colombia bogota- colombia
     
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    bucaramanga colombia bucaramanga colombia
    Bogotá, Colombia Bogota, Colombia
    cartagena cartagena
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Colombia  Colombia 
    Bogotá, Colombia Bogota, Colombia
     
     
    barrancabermeja barrancabermeja
     
    Arauca, Colombia Arauca, Colombia
     
     
     
     
     
     
    Medellin,Co Medellin,Co
    Bogota, Colombia Bogota, Colombia
     
    Pereira Pereira
     
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Colombia Colombia
    Barranquilla-Colombia Barranquilla-Colombia
    Colombia Colombia
     
     
     
     
     
    Bogota D.C Rock City......... Bogota D.C Rock City.........
    Colombia Colombia
     
    Bogota Bogota
    Bogotá, Colombia Bogota, Colombia
     
    Bogotá D.C. Bogota D.C.
    Bogota D.C Bogota D.C
     
    Bogota Bogota
    Washington, DC Washington, DC
     
    laguna de Bogota laguna de Bogota
    Bogota Bogota
     
    Americas Colombia Bogota Americas Colombia Bogota
    Bogota Bogota
     
    4.614064,-74.125958 4.614064,-74.125958
    b b
    cali, colombia cali, colombia
     
     
     
    Bogotá Bogota
     
     
    Bogotá, Colombia Bogota, Colombia
     
     
     
     
    Bogotá, Colombia Bogota, Colombia
    Bogota Bogota
    Buenos Aires  Buenos Aires 
    Medellín, Antioquia Medellin, Antioquia
    Bogota - Colombia Bogota - Colombia
    Barranquilla, Colombia Barranquilla, Colombia
    Bogota,Colombia Bogota,Colombia
    Bogotá Bogota
    Bogotá Bogota
    BARRANQUILLA BARRANQUILLA
     
    colombia colombia
    Barranquilla, Colombia Barranquilla, Colombia
    colombia colombia
    Villavicencio Villavicencio
    COLOMBIA COLOMBIA
     
    Bogota DC Bogota DC
    BOYACA BOYACA
    Global Citizen Global Citizen
    Cartagena de Indias, Colombia Cartagena de Indias, Colombia
    colombia  colombia 
     
    colombia colombia
    SANTA MARTA SANTA MARTA
     
    Colombia Colombia
    Medellín, Colombia Medellin, Colombia
     Nortesantedereana en Medellín  Nortesantedereana en Medellin
    Bogotá, Colombia Bogota, Colombia
     
     
    Colombia Colombia
    Bucaramanga, Colombia Bucaramanga, Colombia
    Medellin Antioquia Medellin Antioquia
     
     
    Guayaquil, Ecuador Guayaquil, Ecuador
    Bogota Bogota
    Colombia-Cordoba-Monteria Colombia-Cordoba-Monteria
     
     
    Colombia Colombia
    Bogota Colombia Bogota Colombia
     
    Colombia Colombia
    colombia  colombia 
     
    Armenia, Quindio, Colombia Armenia, Quindio, Colombia
    Colombia Colombia
    Cali, Valle del Cauca Cali, Valle del Cauca
    Cocalombia_ÜT: 5.42293,-71729  Cocalombia_UT: 5.42293,-71729 
    colombia colombia
     
     
     
    Cali, Colombia Cali, Colombia
    Colombia Colombia
    Miami Beach, FL Miami Beach, FL
    Colombia Colombia
    Bogota Bogota
     
    Bogota Bogota
     
    Santiago de Cali Santiago de Cali
     
     
    Bogotá, Colombia. Bogota, Colombia.
    Medellín Medellin
     
     
    Bogota Bogota
     
    Colombia Colombia
    Bogota Bogota
    Bogota  Bogota 
    Rionegro, Antioquia, Colombia Rionegro, Antioquia, Colombia
    Valledupar Valledupar
     
    Meta - Villavicencio Meta - Villavicencio
    Barcelona Barcelona
    Colombia D. C Colombia D. C
    Puerto Berrío, Colombia Puerto Berrio, Colombia
    El Cerrito Valle del Cauca El Cerrito Valle del Cauca
    Ibagué, Colombia Ibague, Colombia
    COLOMBIA COLOMBIA
     
    en Cartagena en Cartagena
    Bogotá, Colombia Bogota, Colombia
     
    Bogota Bogota
     
     
    Cucuta - Colombia Cucuta - Colombia
     
     
    en algun lugar del mundo  en algun lugar del mundo 
    colombia colombia
     
    Abriendo camino Abriendo camino
     
     
    Colombia Colombia
    Barranquilla Barranquilla
     
    Zulia  Zulia 
     
    Villavicencio Villavicencio
    colombia colombia
    Arauca - Colombia Arauca - Colombia
     
     
    Colombia Colombia
    barranquilla barranquilla
     
    Otra vez en Bogotá Otra vez en Bogota
    Bogotá - Colombia Bogota - Colombia
    Medellín, Colombia Medellin, Colombia
    bogota bogota
     
    Bogotá Bogota
     
    colombia colombia
    En la espalda del Sol En la espalda del Sol
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
     
     
    Chinacota norte de santander Chinacota norte de santander
    bogota bogota
    Colombia Colombia
     
    Bogotá, Colombia Bogota, Colombia
    Bogotá - Colombia Bogota - Colombia
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Philadelphia, Pennsylvania Philadelphia, Pennsylvania
    Fort Lauderdale, FL Fort Lauderdale, FL
    London town, Blighty London town, Blighty
    Bogotá Bogota
    Colombia Colombia
    COLOMBIA COLOMBIA
     
    Bogotá Bogota
    Bogota Bogota
    Colombia Colombia
    Nutopia Nutopia
    Bogotá Bogota
    Bogotá Bogota
     
    Colombia Colombia
     
     
    Ecuador Ecuador
    colombia colombia
    Bogotá Colombia Bogota Colombia
    Mundo Mundo
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Auckland, NZ Auckland, NZ
    Washington, DC Washington, DC
    Bogota, Colombia Bogota, Colombia
    Ecuador Ecuador
    Barcelona  Barcelona 
    Heel Nederland Heel Nederland
    England, United Kingdom England, United Kingdom
    Soest, Netherlands Soest, Netherlands
    Stow on the wold Stow on the wold
    England, United Kingdom England, United Kingdom
    Behind A Camera Behind A Camera
    Earth Earth
    Owen Sound, Ontario, Canada Owen Sound, Ontario, Canada
    Rotterdam  Rotterdam 
    Apeldoorn Apeldoorn
    Apeldoorn Apeldoorn
    Your moms house Your moms house
    Bogota, Colombia Bogota, Colombia
    Oxfordshire, England Oxfordshire, England
    SouthEast Michigan SouthEast Michigan
    Seattle, Washington, USA Seattle, Washington, USA
    France France
    USA USA
    Eugene, Oregon Eugene, Oregon
    Rome, Italy Rome, Italy
    Uxbridge Uxbridge
    Witham, Essex Witham, Essex
    Kent, UK Kent, UK
    Hawkinge, England Hawkinge, England
    Orlando, FL Orlando, FL
    Toronto, ON Toronto, ON
    Colombia-Latam Colombia-Latam
    Houghton, South Africa Houghton, South Africa
     
     
    Bogotá Bogota
    Colombia Colombia
     
    Colombia Colombia
     
    Bogota, Colombia Bogota, Colombia
    Holanda y Alemania Holanda y Alemania
    Merida city shore Merida city shore
    Bogotá Bogota
    Caribe Colombiano Caribe Colombiano
    Colombia Colombia
    Atlanta, GA Atlanta, GA
    Colombia Colombia
    Miami, FL Miami, FL
    Bogotá D.C  Bogota D.C 
    Bogotá, Colombia Bogota, Colombia
    #TrabajoparajóvenesSihay #TrabajoparajovenesSihay
    COLOMBIA COLOMBIA
    Santa Marta (Magdalena) Santa Marta (Magdalena)
    Colombia Colombia
     
    Bogotá Bogota
     
    localhost localhost
     
    Colombia Colombia
     
    Bogotá - Colombia Bogota - Colombia
    Bogota Bogota
    S los angeles  S los angeles 
    Colombia Colombia
     
    Bogotá Bogota
    Europa Europa
    Bogotá, Colombia Bogota, Colombia
    BOGOTA DC- COLOMBIA BOGOTA DC- COLOMBIA
    Cali, Colombia Cali, Colombia
     
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    instagram.com/marcelaalarcon1 instagram.com/marcelaalarcon1
    Colombia Colombia
    Bogotá (Colombia) Bogota (Colombia)
    New York, Atlanta, Miami New York, Atlanta, Miami
    Bogotá Bogota
    bogota bogota
    Bogotá Bogota
    Barrancabermeja Barrancabermeja
    Colombia Colombia
     
    HAZTE SOCIA/O HAZTE SOCIA/O
     
    Bogotá, Colombia Bogota, Colombia
    Bucaramanga, Colombia Bucaramanga, Colombia
    Colombia Colombia
     
     
    México Mexico
     
    Ramallah - Palestine Ramallah - Palestine
    España Espana
    Santa Marta / Magdalena Santa Marta / Magdalena
    Bogotá Bogota
    Málaga-Marbella Malaga-Marbella
    Mexico Mexico
     
     
    Colombia Colombia
     
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Colombia Colombia
    Cali Cali
    Colombia Planeta Tierra Colombia Planeta Tierra
    Bogotá Bogota
    Colombia Colombia
     
     
    México Mexico
    ÜT: 11.380586,-72.241595 UT: 11.380586,-72.241595
    Colombia - España Colombia - Espana
    Ecuador Ecuador
    Bogotá, D.C  Bogota, D.C 
    El Banco, Magdalena. El Banco, Magdalena.
    Bogota D.C Bogota D.C
    Miami Miami
    Massachusetts Massachusetts
    Bogotá Bogota
    Bogotá - Colombia Bogota - Colombia
    ÜT: 4.731827,-74.065069 UT: 4.731827,-74.065069
     
    colombia colombia
    Bogotá Bogota
    Madrid, España Madrid, Espana
    Bogota, Colombia Bogota, Colombia
    Cuba Cuba
    Bogotá., Colombia Bogota., Colombia
    Barcelona, España Barcelona, Espana
    República de Colombia Republica de Colombia
    Colombia Colombia
    Colombia Colombia
    Cynicism As A Service Cynicism As A Service
    Montería, Córdoba Monteria, Cordoba
    Bogotá.Colombia Bogota.Colombia
    Blog: Blog:
    Colombia Colombia
     
    Bogotá, Colombia Bogota, Colombia
    Internet - Libre Internet - Libre
    Colombia Colombia
    Bogotá-Colombia Bogota-Colombia
    Bogota Colombia Bogota Colombia
    Bogotá, Colombia Bogota, Colombia
    Barranquilla, Colombia Barranquilla, Colombia
    Santander, Colombia Santander, Colombia
    Mundial Mundial
    Washington, DC Washington, DC
    Chile Chile
    Cali - Colombia Cali - Colombia
     
     
    New York New York
    Bogotá D.C., Colombia Bogota D.C., Colombia
    Colombia Colombia
    Colombia Colombia
    London London
    Colombia Colombia
    Paris Paris
     
     
    Bogota-Colombia Bogota-Colombia
    Colombia Colombia
    São Paulo Sao Paulo
    Brasilia Brasilia
     
    Aleppo, Syria Aleppo, Syria
    Bogotá Bogota
    Colombia Colombia
    Venezuela Venezuela
     
    Tokyo Tokyo
    San Francisco San Francisco
     
    Colombia Colombia
    Palestine Palestine
    Africa (mostly) Africa (mostly)
    Colombia Colombia
    En Globo En Globo
    日本 東京 Ri Ben  Dong Jing 
    Bogotá - Colombia Bogota - Colombia
     
    , costas y ríos de CO. , costas y rios de CO.
    Buenaventura Buenaventura
    Colombia Colombia
    Ammán, Reino Hachemita de Jord Amman, Reino Hachemita de Jord
    Tokyo Tokyo
    Tumaco Nariño  Tumaco Narino 
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    BOGOTA COLOMBIA BOGOTA COLOMBIA
    Bogotá, Colombia Bogota, Colombia
     
    Free Libya Free Libya
    Santiago Santiago
    Vancouver, British Columbia Vancouver, British Columbia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Bogotá D.C. Bogota D.C.
     
     
    Colombia Colombia
    Armenia Armenia
    Colombia Colombia
    Washington, D.C. Washington, D.C.
    New York, NY New York, NY
    Caracas, Venezuela Caracas, Venezuela
    Qatar  Qatar 
     
    United States United States
    Venezuela Venezuela
    Ciudad Autónoma de Buenos Aire Ciudad Autonoma de Buenos Aire
    En todas partes En todas partes
    Milwaukee, Wisconsin Milwaukee, Wisconsin
    en el Holocausto de Mexico  en el Holocausto de Mexico 
    Libya/UK Libya/UK
    Hispanoamerica Hispanoamerica
    Greece Greece
     
    Bucaramanga Bucaramanga
    Bogota, Colombia Bogota, Colombia
    ÜT: 25.75395,-80.20197 UT: 25.75395,-80.20197
    Colombia Colombia
    Medellin - Colombia Medellin - Colombia
    Colombia Colombia
    Perú Peru
     
    Alfaz y Finestrat (Alicante) Alfaz y Finestrat (Alicante)
    Worldwide Worldwide
    Lima, Perú Lima, Peru
     
    Madrid, España Madrid, Espana
     
    Bogotá Bogota
    Bogotá Bogota
    Bogotá Bogota
    Standing Next To You Standing Next To You
    Cairo Cairo
    UK UK
     
    Doha, Qatar Doha, Qatar
    Sydney Sydney
    Bogotá Bogota
    New York City New York City
     
    somewhere on the planet somewhere on the planet
    Lima Lima
    Colombia Colombia
    Chile Chile
    Petrópolis, RJ, Brazil Petropolis, RJ, Brazil
    Escritor, mamerto y Senador de la República. Escritor, mamerto y Senador de la Republica.
     
    Global Global
    Diné Bikeyah Dine Bikeyah
    Michigan/New York City Michigan/New York City
    London, England  London, England 
    Doha, Qatar Doha, Qatar
     
    NYC NYC
    Everywhere Everywhere
    Harare, Zimbabwe Harare, Zimbabwe
    Global Global
     
     
    London, Wales, wherever London, Wales, wherever
     
    Vancouver Vancouver
    Kanata/Canada Kanata/Canada
    [unofficial account] [unofficial account]
    New York City New York City
    Earth Earth
    North America North America
    Washington, DC Washington, DC
    DC DC
    Washington, D.C. Washington, D.C.
    Canada Canada
    New York New York
     
    Washington, D.C.  Washington, D.C. 
    Earth Earth
    Berkeley, CA Berkeley, CA
     
    New York, NY New York, NY
    Mexico City Mexico City
    Oakland, California Oakland, California
    Cambridge, Mass. Cambridge, Mass.
    Corvallis, Oregon, USA Corvallis, Oregon, USA
    Devon Devon
    Hong Kong Hong Kong
    North America North America
     
    New York, NY New York, NY
    Berkeley, CA Berkeley, CA
     
    London London
    New York New York
    Canada Canada
    oakland, ca (and everywhere) oakland, ca (and everywhere)
     
    Topeka, KS Topeka, KS
    The Bright Continent The Bright Continent
    New York, NY New York, NY
    London London
    New Haven, CT New Haven, CT
    New York, NY New York, NY
     
    BK, #NYUAD,UAE. All views mine BK, #NYUAD,UAE. All views mine
    Portland, OR & Washington, DC Portland, OR & Washington, DC
    New York, USA New York, USA
    kcaldeira@carnegiescience.edu kcaldeira@carnegiescience.edu
    YWG to DCA YWG to DCA
    Global Global
    New York City New York City
    Edinburgh, Scotland Edinburgh, Scotland
    Edinburgh, Scotland Edinburgh, Scotland
    London London
    New York/New Jersey New York/New Jersey
    New York City New York City
    United States United States
    California, USA California, USA
    Seoul Mumbai  Moscow Prague  Seoul Mumbai  Moscow Prague 
    Paris, France Paris, France
    Princeton, NJ Princeton, NJ
    London, UK London, UK
    Mexico City Mexico City
    Toronto, Canada Toronto, Canada
     
    Bogotá, Colombia Bogota, Colombia
     
    Colombia Colombia
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Bogotá, Colombia Bogota, Colombia
    Argentina Argentina
    Macondo Macondo
     
    Cuba Cuba
    Kent, OH Kent, OH
    Washington D.C. Washington D.C.
    Washington, DC Washington, DC
    Mexico Mexico
    colombia colombia
    Washington, DC Washington, DC
    Venezuela Venezuela
    Bogotá, Colombia Bogota, Colombia
    United States United States
     
     
    Around the world Around the world
    New York, NY New York, NY
    Mennecy Mennecy
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
     
    New York City New York City
    London London
    Bogotá, Colombia Bogota, Colombia
    Caracas Caracas
     
    Anti Censorville Anti Censorville
    Colombia Colombia
    Europe & America Europe & America
     
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá Bogota
    Brasília Brasilia
    Venezuela Venezuela
    Cuba Cuba
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Cartagena+Barranquilla+aviones Cartagena+Barranquilla+aviones
    Madrid Madrid
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    It’s Colombia, not Columbia It's Colombia, not Columbia
    Bogotá, DC, Colombia Bogota, DC, Colombia
    Bogotá Bogota
    Puerto Rico / Argentina Puerto Rico / Argentina
    Bogotá Bogota
     
    Colombia Colombia
    Everywhere Everywhere
     
    Colombia Colombia
    Colombia Colombia
    Bogotá Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    ÜT: 4.6681601,-74.0519948 UT: 4.6681601,-74.0519948
    Colombia Colombia
    Bogota, Colombia 3208475012 Bogota, Colombia 3208475012
    Bogotá, Colombia Bogota, Colombia
    ÜT: 4.669251,-74.044541 UT: 4.669251,-74.044541
    Quito, Ecuador Quito, Ecuador
    Caracas, Venezuela Caracas, Venezuela
    Bogotá, Colombia. Bogota, Colombia.
     
    Edinburgh, UK Edinburgh, UK
    Everywhere! Everywhere!
    Cali, Colombia Cali, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Bogotá Colombia Bogota Colombia
    Cucuta Cucuta
     
    Bogotá Bogota
     
     
     
    Bogotá, Colombia Bogota, Colombia
    ÜT: 4.627714,-74.067632 UT: 4.627714,-74.067632
    Atlanta -GA Atlanta -GA
    Colombia Colombia
     
    Bogotá Bogota
    In my shoes In my shoes
    Bogotá Bogota
    Colombia Colombia
    Bogotá (Colombia) Bogota (Colombia)
    Bogota, Colombia Bogota, Colombia
    Bogotá, Colombia Bogota, Colombia
    Sogamoso Sogamoso
    Colombia Colombia
    Bogota - Colombia Bogota - Colombia
     
    Bogotá, Colombia Bogota, Colombia
     
    Bogotá, Colombia Bogota, Colombia
    Bogotá, D.C. Bogota, D.C.
     
     
    Cartagena de Indias, Colombia Cartagena de Indias, Colombia
    Santa Marta D.T.C.H. Colombia Santa Marta D.T.C.H. Colombia
    Detrás del mundo Detras del mundo
    Reading, England Reading, England
    Bogotá Bogota
    Bogota - Cartagena (Colombia) Bogota - Cartagena (Colombia)
    Bogotá, Colombia Bogota, Colombia
     
    Colombia Colombia
    Cartagena de Indias, Colombia Cartagena de Indias, Colombia
    Sweden Sweden
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Internet Internet
    Cambridge, MA Cambridge, MA
    Bogotá, Colombia Bogota, Colombia
    Buenos Aires, Argentina Buenos Aires, Argentina
    Medellín / Carmen de Viboral Medellin / Carmen de Viboral
    colombia colombia
    Barranquilla - Bogotá - México Barranquilla - Bogota - Mexico
    Nashville, TN Nashville, TN
    Colombia Colombia
    colombia colombia
    Around the World Around the World
    Bogotá Bogota
    Bogotá  Bogota 
    Bogota Bogota
    Colombia Colombia
    Bogota, Colombia Bogota, Colombia
     
     
    US,LATAM US,LATAM
    Colombia Colombia
    Medellin Medellin
    Colombia Colombia
    All places All places
    Key Biscayne , Fla /  Bogotá Key Biscayne , Fla /  Bogota
    Medellin-Colombia Medellin-Colombia
     
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Bogota, Colombia Bogota, Colombia
     
    Medellín Medellin
    Madrid, España Madrid, Espana
    Colombia Colombia
    Palma de Mallorca Palma de Mallorca
    Madrid Madrid
    New York City New York City
     
    Medellín, Colombia Medellin, Colombia
    Colombia Colombia
    Madrid / Bogota  Madrid / Bogota 
    Colombia Colombia
     
    Bogotá, Colombia Bogota, Colombia
    Medellín, Colombia Medellin, Colombia
     
     
     
    Colombia Colombia
    Argentina Argentina
    Manizales, Caldas Manizales, Caldas
    Colombia Colombia
    Colombia Colombia
    Bogotá, D.C. Bogota, D.C.
     
    Leuven, Belgium Leuven, Belgium
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Barranquilla Colombia Barranquilla Colombia
    New York, NY New York, NY
    Chicago Chicago
    London, England London, England
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Bogota, Colombia Bogota, Colombia
    Colombia Colombia
    Colombia Colombia
    Todos podemos cambiar el mundo Todos podemos cambiar el mundo
     
    Colombia Colombia
     
     
    Colombia Colombia
     
    bogota bogota
     
    Colombia Colombia
    Colombia Colombia
     
    Santa Marta Santa Marta
    Yopal  Yopal 
     
    Colombia Colombia
    Barranquilla Barranquilla
    BOGOTA, COLOMBIA BOGOTA, COLOMBIA
    Lima - Peru Lima - Peru
     
    Bogota colombia Bogota colombia
    COLOMBIA COLOMBIA
     
     
    barranquilla barranquilla
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Region Caribe Region Caribe
     
    BOGOTA BOGOTA
     
     
     
    Barranquilla Barranquilla
    Medellín, Colombia Medellin, Colombia
    Colombia Colombia
    Colombia Colombia
    Cualquier lugar del mundo Cualquier lugar del mundo
    La Heroica La Heroica
     
     
    Villavicencio, Colombia Villavicencio, Colombia
    Bogota DC Bogota DC
    Medellín, Colombia Medellin, Colombia
     
     
     
    Riohacha, Colombia Riohacha, Colombia
     
     
    Cúcuta, Colombia Cucuta, Colombia
    Medellín, Colombia Medellin, Colombia
    Bogota - Colombia Bogota - Colombia
     
    Machala Machala
     
    Medellín Medellin
    Valle del Cauca, Colombia Valle del Cauca, Colombia
    COLOMBIA COLOMBIA
    Colombia Colombia
    Venezuela Venezuela
     
    Bogotá, Colombia Bogota, Colombia
     
    Bogota Colombia Bogota Colombia
     
     
     
     
    Cartagena, Colombia Cartagena, Colombia
     
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Cartagena, Colombia Cartagena, Colombia
     
     
    COLOMBIA COLOMBIA
     
     
    ÜT: 11.22949,-74.214569 UT: 11.22949,-74.214569
     
    Cartagena, Bolívar Cartagena, Bolivar
     
    Colombia Colombia
    Bogota D.C Bogota D.C
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Medellín Medellin
    Villavicencio Villavicencio
     
    BOGOTA, COLOMBIA BOGOTA, COLOMBIA
    Santa Fe De Bogotá Santa Fe De Bogota
     
     
    Zipaquirá - Bogotá.  Zipaquira - Bogota. 
    Bogotá, Colombia Bogota, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Popayán, Colombia Popayan, Colombia
    Bogotá D.C Bogota D.C
    Colombia Colombia
     
    Miami, FL Miami, FL
    Auckland, New Zealand Auckland, New Zealand
     
    DEPARTAMENTO VALLE DEL CAUCA DEPARTAMENTO VALLE DEL CAUCA
    Colombia Colombia
    United States United States
     
    Bogotá, Colombia Bogota, Colombia
     
    Denver Denver
     
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
     
    Colombia Colombia
    France France
    Bogotá, Carrera 9 No.74-08 P.9 Bogota, Carrera 9 No.74-08 P.9
    Venezuela Venezuela
    VENEZUELA VENEZUELA
    Sucre, Miranda Venezuela Sucre, Miranda Venezuela
    Caracas, Venezuela Caracas, Venezuela
    Venezuela Venezuela
    Venezuela Venezuela
    Venezuela Venezuela
    Venezuela Venezuela
    Santiago, Chile Santiago, Chile
    Bogotá Bogota
    Redwood City, CA Redwood City, CA
     
     
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
     
     
    Colombia Colombia
     
    Colombia Colombia
     
    Buenos Aires, Argentina Buenos Aires, Argentina
    Miami Miami
    Papineau Papineau
    Colombia Colombia
    COLOMBIA COLOMBIA
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Washington, D.C. Washington, D.C.
    Venezuela  Venezuela 
    Neiva, Huila, Colombia Neiva, Huila, Colombia
    Utopía ✞☯  Utopia  
    AQUI y ALLA  🤔👇👆COLOMBIA AQUI y ALLA  COLOMBIA
    Bogota Bogota
    Cali Cali
    Santander, Colombia Santander, Colombia
    LatAmC LatAmC
     Tumaco  Tumaco
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    El Caribe, Colombia. El Caribe, Colombia.
    Medellin,Antioquia-Colombia Medellin,Antioquia-Colombia
     
    Colombia Colombia
    EEUU EEUU
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Cordoba  Cordoba 
    Bogota,Colombia Bogota,Colombia
     
    Bogotá Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Argentina Argentina
    Las Condes, Chile Las Condes, Chile
    Argentina Argentina
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Cuba Cuba
    Colombia Colombia
    Cali, Colombia Cali, Colombia
    Desubicada a veces Desubicada a veces
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Los Angeles, CA Los Angeles, CA
    Bogota Bogota
     
     
    Colombia Colombia
     
    Medellín, Colombia Medellin, Colombia
    Bogotá, Colombia Bogota, Colombia
     
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Medellin Medellin
    Medellin, Colombia Medellin, Colombia
    colombia colombia
    Barranquilla Barranquilla
    COLOMBIANO URIBISTA 1000% COLOMBIANO URIBISTA 1000%
    Santa Rosa del Sur, Colombia Santa Rosa del Sur, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Orito, Colombia Orito, Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Cartagena - Colombia Cartagena - Colombia
     
     
    Caribe colombiano. Caribe colombiano.
     
    Cartagena, Colombia Cartagena, Colombia
     
     
     
     
     
     
    Bogotá, Colombia Bogota, Colombia
    Bogotá Bogota
     
     
    San Francisco San Francisco
    el man esta vivo el man esta vivo
    Cali Colombia Cali Colombia
     
    Turbo Turbo
    Colombia Colombia
     
     
     
    United States United States
    Dagua Dagua
     
     
    Girardot, Colombia Girardot, Colombia
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Miami Beach, FL Miami Beach, FL
     
    Cali, Valle del Cauca Cali, Valle del Cauca
    Aguadas, Colombia Aguadas, Colombia
    Santa Marta (Colombia) Santa Marta (Colombia)
     
    Medellín, Antioquia Medellin, Antioquia
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
     
    Campana, Argentina Campana, Argentina
    Cali, Valle del Cauca Cali, Valle del Cauca
    Cali, Valle del Cauca Cali, Valle del Cauca
    Pereira, Risaralda Pereira, Risaralda
    Cali - Valle del Cauca Cali - Valle del Cauca
    Huila Huila
     
    Colombia Colombia
    Colombia Colombia
    Barranquilla Barranquilla
    Colombia Colombia
    Montería - Bogotá Monteria - Bogota
    Bogotá D.C. - Colombia Bogota D.C. - Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Yopal, Casanare (Colombia) Yopal, Casanare (Colombia)
    Colombia Colombia
     
     
    Colombia Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
     
     
    Colombia Colombia
     
    Colombia Colombia
     
    Montería - Córdoba. Monteria - Cordoba.
    Colombia Colombia
    Barranquilla, Colombia Barranquilla, Colombia
    Antioquia Antioquia
    Pereira Pereira
    Barranquilla - Atlántico Barranquilla - Atlantico
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Nariño, Colombia Narino, Colombia
    Medellin Medellin
    Sincelejo, Colombia Sincelejo, Colombia
     
    Colombia Colombia
    Colombia Colombia
    Valle de Aburrá Valle de Aburra
    Puerto Rico Puerto Rico
    Venezuela Venezuela
     
     
    Bogotá, Colombia Bogota, Colombia
    Popayán, Colombia Popayan, Colombia
     
    NYC NYC
     
    Nueva York Nueva York
    COLOMBIA COLOMBIA
    Bogota D.C. Colombia Bogota D.C. Colombia
    Washington, D.C. Washington, D.C.
    Washington, D.C. Washington, D.C.
    Washington, D.C./NoVa Washington, D.C./NoVa
    México Mexico
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá DC, Colombia  Bogota DC, Colombia 
     
    Medellín Medellin
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Edinburgh, UK Edinburgh, UK
     
    Samaria en Bogotá Samaria en Bogota
    @ifbbmt @ifbbmt
    Medellin Colombia Medellin Colombia
     
     
    Des Ubicada   Des Ubicada  
    Colombia Colombia
    Colombia Colombia
    Panama Panama
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    4.599836,-74.07371 4.599836,-74.07371
    Nairobi Nairobi
    Medellín, Colombia Medellin, Colombia
     
    fonseca la guajira fonseca la guajira
    IdeasLocalesQueConstruyenPais  IdeasLocalesQueConstruyenPais 
     
    Washington, DC Washington, DC
     
    Bogotá, Colombia Bogota, Colombia
    en la POLÍTICA en la POLITICA
    Medellín, Colombia Medellin, Colombia
    Santiago de Cali Santiago de Cali
    Beijing, Rep. Popular China Beijing, Rep. Popular China
    Munich, Baviera Munich, Baviera
     
    New York New York
     
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Cali, Valle del Cauca,Colombia Cali, Valle del Cauca,Colombia
    Neiva, Huila Neiva, Huila
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Valledupar, Cesar, Colombia Valledupar, Cesar, Colombia
    Barranquilla Barranquilla
    Madrid/Latin America Madrid/Latin America
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Madrid, Spain Madrid, Spain
    Bogotá-Colombia Bogota-Colombia
     
    Bogotá DC Bogota DC
    bogota colombia bogota colombia
    Santiago, Chile Santiago, Chile
    Madrid, Spain Madrid, Spain
    Colombia Colombia
    Instagram @francorjorge Instagram @francorjorge
     
    Bogotá D.C. Bogota D.C.
    Bogotá, Colombia Bogota, Colombia
    221B, Baker Street 221B, Baker Street
    Chile Chile
    Latin America Latin America
     
    URUGUAY URUGUAY
    Cali Cali
     
    Chia, Colombia Chia, Colombia
     
     
    Colombia Colombia
    Colombia Colombia
    Bogotá D.C.  Bogota D.C. 
    Av carrera 24 # 37-09 #Bogota  Av carrera 24 # 37-09 #Bogota 
    BOGOTÁ BOGOTA
     
    Chía, Colombia Chia, Colombia
    Birmingham-UK Medellin-COL Birmingham-UK Medellin-COL
    Colombia Colombia
    Cali - Colombia Cali - Colombia
    Colombia - Bogota D.C. Colombia - Bogota D.C.
    Bogotá, Colombia Bogota, Colombia
    Bogotá Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    11.009303,-74.808855 11.009303,-74.808855
    Colombia Colombia
    Bogotá Bogota
    Colombia Colombia
    Bogotá D.C. Bogota D.C.
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    UNETE Y ESCRIBE  UNETE Y ESCRIBE 
    Colombia Colombia
    Colombia 🇨🇴 Colombia 
     
    Barranquilla, Colombia Barranquilla, Colombia
    Cartagena, Colombia Cartagena, Colombia
    Cali, Colombia Cali, Colombia
    Medellín,Colombia Medellin,Colombia
    colombia colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Bogotá, Colombia Bogota, Colombia
     
    Cali- Colombia Cali- Colombia
     
     
    Barcelona, Spain Barcelona, Spain
     
    Bogota Colombia Bogota Colombia
    Barranquilla-Cali-Bogotá D.C. Barranquilla-Cali-Bogota D.C.
    Cali - Colombia Cali - Colombia
     
     
    Barranquilla, Colombia Barranquilla, Colombia
    Bogotá Bogota
    Fort Lauderdale, FL Fort Lauderdale, FL
    Medellín, Colombia Medellin, Colombia
     
     
     
    Medellin, Colombia Medellin, Colombia
     
     
    Madrid, España Madrid, Espana
    Mundial Mundial
    Medellin Medellin
    Bogotá Bogota
    Cúcuta, Colombia Cucuta, Colombia
    Bogota, Colombia Bogota, Colombia
    Bogotá Distrito Capital Bogota Distrito Capital
     
    Bucaramanga - Santander Bucaramanga - Santander
     
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
     
     
     
    Bogotá, Colombia Bogota, Colombia
    Bucaramanga Bucaramanga
     
     
    florida,uruguay florida,uruguay
    Bogotá, Colombia Bogota, Colombia
     
    Indonesia Indonesia
    COLOMBIA COLOMBIA
     
    México-Colombia Mexico-Colombia
    Paris, France Paris, France
    Bogotá - Colombia Bogota - Colombia
     
    Colombia Colombia
    Bogotá Bogota
     
    Colombia Colombia
     
    Colombia Colombia
    Exilio Exilio
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Colombia Colombia
    New York, NY New York, NY
     
     
    COLOMBIA. COLOMBIA.
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    instagram @mariafelina  instagram @mariafelina 
    Bogota Bogota
    Colombia Colombia
     
    ÜT: 4.595704,-74.076151 UT: 4.595704,-74.076151
    PAN AFRICA  PAN AFRICA 
    Bogotá, Colombia Bogota, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Planeta Tierra Planeta Tierra
     
    Valledupar, Cesar, Colombia Valledupar, Cesar, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
     
    New York City New York City
    Berlin, Germany Berlin, Germany
     
    Washington, D.C. Washington, D.C.
    Spain Spain
    London London
     
    Washington, DC Washington, DC
    Colombia Colombia
    Washington, DC Washington, DC
    La Paz, Bolivia La Paz, Bolivia
    Ciudad de Mexico Ciudad de Mexico
    Colombia - Argentina - México  Colombia - Argentina - Mexico 
    New Haven CT New Haven CT
    Bogota, Colombia Bogota, Colombia
    Paris, France Paris, France
    Washington DC Washington DC
    Washington, DC Washington, DC
    London, UK London, UK
    Bogotá; Colombia Bogota; Colombia
     
     
     
    Baltimore & Paris Baltimore & Paris
    La Plata, Argentina La Plata, Argentina
    Bogotá, Colombia Bogota, Colombia
     
     
     
     
    Buenos Aires, Argentina Buenos Aires, Argentina
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Medellín Medellin
     
    Bogotá, Colombia Bogota, Colombia
     
     
    Venezuela Venezuela
    Bog\Vvc\Colombia Bog\Vvc\Colombia
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Envigado, Antioquia Envigado, Antioquia
    Bogotá, Colombia Bogota, Colombia
    Montevideo, Uruguay Montevideo, Uruguay
     
    Bucaramanga, Colombia Bucaramanga, Colombia
     
    ÜT: 4.7102328,-74.0317432 UT: 4.7102328,-74.0317432
     
    Latinamerica Latinamerica
    Bogotá, Colombia Bogota, Colombia
    Bogotá- Colombia Bogota- Colombia
    Colombia Colombia
    Bogotá - Colombia Bogota - Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Medellín - Colombia Medellin - Colombia
    Uribia la guajira Uribia la guajira
    Con Colombia Siempre Con Colombia Siempre
    Florida, USA Florida, USA
    Washington, DC Washington, DC
    Bogotá, D.C. - Colombia Bogota, D.C. - Colombia
     
    Bogotá Colombia Bogota Colombia
     
    Bogotá Bogota
    Paris, France / São Paulo Paris, France / Sao Paulo
    Sincelejo,Sucre Sincelejo,Sucre
    Bogota, Colombia Bogota, Colombia
    Colombia Colombia
    World HQ in Broomfield, CO World HQ in Broomfield, CO
     
    Colombia Colombia
    New York, NY New York, NY
    Bogota, Colombia Bogota, Colombia
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    London London
     
    New York New York
     
    New York, NY New York, NY
    New York, NY New York, NY
     
    Bogotá, Colombia Bogota, Colombia
    Medellín, Antioquia Medellin, Antioquia
    Bogotá Bogota
    Mexico City Mexico City
    Washington, DC Washington, DC
    ÜT: 4.59517,-74.077369u UT: 4.59517,-74.077369u
    Bogotá D.C., Colombia Bogota D.C., Colombia
    Bogotá, Colombia Bogota, Colombia
     
    Santiago, Chile Santiago, Chile
    Washington, DC Washington, DC
    Armenia Armenia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Bogotá Bogota
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia- Teléfono (1) 5187000 cgr@contraloria.gov.co Colombia- Telefono (1) 5187000 cgr@contraloria.gov.co
     
    Bogotá, Colombia Bogota, Colombia
    Bogota, Colombia Bogota, Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá, Colombia Bogota, Colombia
    República de Colombia Republica de Colombia
    , costas y ríos de CO. , costas y rios de CO.
    Colombia Colombia
    Colombia Colombia
    Bogotá - Colombia Bogota - Colombia
    Bogotá, Colombia. Bogota, Colombia.
    Colombia Colombia
    Colombia Colombia
    Bogotá, D.C. - Colombia Bogota, D.C. - Colombia
     
    Colombia Colombia
    Bogotá Bogota
    Colombia Colombia
     
     
    New York, NY New York, NY
    ÜT: 10.999549,-74.801298 UT: 10.999549,-74.801298
    New York, USA New York, USA
     
     
     
    Barranquilla - Colombia Barranquilla - Colombia
    iPhone: 32.799828,-96.784111 iPhone: 32.799828,-96.784111
     
    Valledupar, Cesar Valledupar, Cesar
     
    Cali / Nueva York Cali / Nueva York
     
    colombia colombia
     
     
     
     
    Colombia Colombia
    Wellington Florida Wellington Florida
    Medellin/ colombia Medellin/ colombia
    Where Needed Where Needed
    Middleburg, Virginia Middleburg, Virginia
     
     
     
    Bogotá - Colombia Bogota - Colombia
    Bogota Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    USA USA
    ÜT: 10.995413,-74.813665 UT: 10.995413,-74.813665
    En mi amada Bogotá En mi amada Bogota
     
    Guayaquil, Ecuador Guayaquil, Ecuador
    Bogotá D.C Bogota D.C
     
    Bogotá Bogota
     
     
     
    Bogotá Bogota
     
     
    Bogotá-Colombia Bogota-Colombia
    USA / Colombia / Peru / Brasil USA / Colombia / Peru / Brasil
     
    Paris Paris
     
     
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Medellín, Colombia Medellin, Colombia
    Santiago, Chile Santiago, Chile
     
    Madrid Madrid
     
     
     
    Washington, DC Washington, DC
    Bogota - Colombia Bogota - Colombia
     
     
     
    New York, NY New York, NY
    Washington DC Washington DC
     
     
    Petro's warehouse Petro's warehouse
     
     
    CR CR
    Bogotá Bogota
     
    Bogota Bogota
    Bogotá D.C. Bogota D.C.
    Washington, DC Metro Area;  Washington, DC Metro Area; 
     
     
     
    Carlos Casares  Carlos Casares 
     
    Glasgow Glasgow
     
     
     
    Washington DC Washington DC
    Washington D.C. Washington D.C.
     
     
    Colombia Colombia
    Lima Lima
     
    medellin medellin
    Madrid, Comunidad de Madrid Madrid, Comunidad de Madrid
     
    Israel Israel
     
    Washington, DC Washington, DC
     
     
     
     
    Hollywood, FL Hollywood, FL
     
     
     
    Bogotá, Colombia Bogota, Colombia
     
    SANTIAGO DE CALI SANTIAGO DE CALI
     
    Miami, Florida Miami, Florida
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Washington, DC Washington, DC
    Bogota Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
     
    Medellín, Colombia Medellin, Colombia
    Port au Prince, Haiti Port au Prince, Haiti
    Montevideo, Uruguay Montevideo, Uruguay
     
     
     
    Of. 56802275 / Cel  5532238835 Of. 56802275 / Cel  5532238835
     
     
    Washington, DC Washington, DC
    Brasil Brasil
    Ciudad de México Ciudad de Mexico
    Colombia Colombia
    Colombia Colombia
    Bogota - COLOMBIA Bogota - COLOMBIA
     
     
    Ithaca, NY Ithaca, NY
     
     
     
    Bogotá - Bogota -
    Bogota Bogota
     
     
    Helsinki, Finland Helsinki, Finland
     
    Bogotá Bogota
    Colombia Colombia
    Madrid, Comunidad de Madrid Madrid, Comunidad de Madrid
    New York, NY New York, NY
    Cereté Cordoba Cerete Cordoba
     
    En toda Colombia En toda Colombia
    Venezuela Venezuela
    Cali-Colombia Cali-Colombia
     
    Ontario, Canada Ontario, Canada
    Cali Colombia Cali Colombia
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Cali, Colombia Cali, Colombia
    América Latina America Latina
    Colombia Colombia
     
    COLOMBIA COLOMBIA
     
    Bogotá, Colombia Bogota, Colombia
    Bogotá Bogota
    BOGOTA COLOMBIA BOGOTA COLOMBIA
    Cali, Colombia Cali, Colombia
    mongolia mongolia
     
    Cali Valle del Cauca  Colombia Cali Valle del Cauca  Colombia
    Medellin  Medellin 
    Bogotá Bogota
    Bogotá Bogota
    Cali, Valle, colombia Cali, Valle, colombia
    Colombia  Colombia 
     
    Colombia Colombia
    New York City New York City
     
    Washington, DC Washington, DC
    Cucuta, Colombia Cucuta, Colombia
    Colombia Colombia
    France France
    Bogotá, Colombia Bogota, Colombia
    Medellín, Colombia Medellin, Colombia
    Palmira, Colombia Palmira, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, DC, Colombia Bogota, DC, Colombia
    Colombia Colombia
    VENEZUELA VENEZUELA
    Tigre, Argentina. Tigre, Argentina.
    Medellín Medellin
     
    Barranquilla  Barranquilla 
    Bogotá Bogota
    Medellín, Colombia Medellin, Colombia
     
    Ibagué, Colombia Ibague, Colombia
    Bogota, Colombia Bogota, Colombia
     
    Bogotá, Colombia Bogota, Colombia
    Mónaco Monaco
     
    @jhpelaez ™ @jhpelaez (tm)
     
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Montería - Colombia Monteria - Colombia
    Monteria, Cordoba. Monteria, Cordoba.
    Colombia Colombia
    Colombia Colombia
    Santa Marta, Colombia Santa Marta, Colombia
    Bogotá Bogota
    Antioquia, Colombia Antioquia, Colombia
    Colombia Colombia
     
    Bogotá, D.C. Bogota, D.C.
    Colombia Colombia
    New York, NY New York, NY
     
    Chicago, IL Chicago, IL
    Chicago, Illinois Chicago, Illinois
    Bogotá, Colombia Bogota, Colombia
    Bogota Bogota
    República de Colombia Republica de Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, Colombia  Bogota, Colombia 
    Bogotá, Colombia Bogota, Colombia
     
    Cali - Valle Cali - Valle
     
    Bogota D.C. Bogota D.C.
    Medellín Medellin
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Bogota, Colombia Bogota, Colombia
    Bogota, Colombia Bogota, Colombia
    Bogotá  Bogota 
     
    Bogotá - Colombia Bogota - Colombia
    Latinoamérica Unida Latinoamerica Unida
    Cali, Colombia Cali, Colombia
    Colombia Colombia
     
    Bogotá D.C., Colombia Bogota D.C., Colombia
    Bogotá Bogota
    Bogotá Bogota
    Bogotá, Colombia Bogota, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Bogotá Bogota
    Brooklyn/Buenos Aires/Toronto Brooklyn/Buenos Aires/Toronto
    Artistic Director, Leadership Artistic Director, Leadership
    NYC NYC
    COLOMBIA COLOMBIA
    Colombia Colombia
    London London
    Córdoba Cordoba
    Cúcuta, Colombia Cucuta, Colombia
     
    ♥ Colombia  Colombia
     
    #Colombia #Colombia
    Colombia Colombia
     
    Escazú, Costa Rica Escazu, Costa Rica
     
    Medellin Medellin
    Bogotá, Colombia Bogota, Colombia
     
     
    Nariño Narino
    Bogota Bogota
    Medellín, Colombia Medellin, Colombia
    Santa Marta y Bogotá Santa Marta y Bogota
    Andorra Andorra
     
    New York, NY New York, NY
    Santa Rosa de Osos Santa Rosa de Osos
     
    Preorder PRESIDENTS OF WAR: Preorder PRESIDENTS OF WAR:
     
    Medellín, Colombia Medellin, Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá D.C, Colombia. Bogota D.C, Colombia.
    Washington, DC Washington, DC
    Tuluá-Valle-Colombia Tulua-Valle-Colombia
    COLOMBIA COLOMBIA
     
    4°35’56’’57---74°04’51’’30 4deg35'56''57---74deg04'51''30
    Colombia  Colombia 
    REPUBLICA FEDERAL DE COLOMBIA REPUBLICA FEDERAL DE COLOMBIA
    Colombia Colombia
    Paris, France Paris, France
    Caracas, Venezuela Caracas, Venezuela
     
    Colombia. Colombia.
    Bogotá, Colombia Bogota, Colombia
    Washington, DC Washington, DC
     
     
    políticamente correcto politicamente correcto
     
    Bogotá, DC, Colombia Bogota, DC, Colombia
    Valledupar Valledupar
    Viena, Austria Viena, Austria
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Boston Boston
    Las Pizarrinas Las Pizarrinas
     
    Boston, MA Boston, MA
     
    Washington DC Washington DC
    Washington, DC Washington, DC
    Graduate Institute, Geneva Graduate Institute, Geneva
    Washington, D.C. Washington, D.C.
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    New York, Washington DC, Miami New York, Washington DC, Miami
    América Latina America Latina
    Bogotá, Colombia Bogota, Colombia
    Santiago de Chle Santiago de Chle
    Colombia Colombia
    valledupar - Colombia valledupar - Colombia
    New York, USA New York, USA
     
    Bogotá, Colombia Bogota, Colombia
     
     
    Caldas-Bogotá Caldas-Bogota
     
          Anywhere       Anywhere
    Loja-Ecuador Loja-Ecuador
    Washington, DC Washington, DC
    Bogotá. COLOMBIA Bogota. COLOMBIA
    planeta tierra,  planeta tierra, 
    Dallas (EU) Dallas (EU)
     
    Medellin, Colombia Medellin, Colombia
     
     
    Colombia Colombia
    Medellín, Colombia Medellin, Colombia
    Pereira, Colombia Pereira, Colombia
    Bogota Bogota
    colombia colombia
    Antioquia Antioquia
     
     
    CHILE CHILE
     
     
     
    ÜT: 4.2119656,-74.6848978 UT: 4.2119656,-74.6848978
    Colombia Colombia
    Bogota D.C. Bogota D.C.
     
    Colombia Colombia
     
    Colombia Colombia
    Medellín, Antioquia Medellin, Antioquia
    Bogotá, Colombia Bogota, Colombia
    New York, NY/Boston, MA New York, NY/Boston, MA
    New York City New York City
     
    Ibagué, Colombia Ibague, Colombia
    Medellin Medellin
     
    La Ciudad Bonita, Colombia La Ciudad Bonita, Colombia
    Medellín, Colombia Medellin, Colombia
    Tegucigalpa Tegucigalpa
    Colombia Colombia
    Washington, DC Washington, DC
     
     
    Bogotá, Colombia. Bogota, Colombia.
     
     
    Argentina Argentina
     
    Medellín Medellin
    ÜT: 4.622501,-74.064933 UT: 4.622501,-74.064933
    Colombia Colombia
     
    Caracas Caracas
    Belfast, Northern Ireland Belfast, Northern Ireland
    Mendoza, Argentina Mendoza, Argentina
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Colombia Colombia
    Madrid Madrid
    Colombia Colombia
     
    Medellín, Colombia Medellin, Colombia
    Medellín, Colombia Medellin, Colombia
    Bogotá Bogota
    San Juan, Puerto Rico San Juan, Puerto Rico
    Ibagué, Tolima Ibague, Tolima
    MEDELLÍN MEDELLIN
     
    BOGOTÁ, Colombia  BOGOTA, Colombia 
    Medellin Medellin
    Madrid, Spain Madrid, Spain
    Colombia Colombia
    Ormond Beach, FL Ormond Beach, FL
     
    ÜT: 6.210789,-75.564233 UT: 6.210789,-75.564233
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Colombia Colombia
     
    Bogotá, Colombia Bogota, Colombia
    Cable Noticias Cable Noticias
    Bogotá Bogota
     
    Bogotá COLOMBIA Bogota COLOMBIA
    Washington D.C. Washington D.C.
    Bogota, Colombia Bogota, Colombia
     
     
    Medellín - Colombia Medellin - Colombia
     
    Bogotá, Colombia Bogota, Colombia
    Estados Unidos Estados Unidos
    CCS CCS
     
    Venezuela Venezuela
    Washington DC, Estados Unidos Washington DC, Estados Unidos
     
    España, Venezuela & Colombia Espana, Venezuela & Colombia
    Bogota Bogota
    Medellin, Colombia Medellin, Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
     
    Yopal, Casanare, Colombia Yopal, Casanare, Colombia
    Colombia Colombia
     
    Bogota, Colombia Bogota, Colombia
     
     
     
    Colombia Colombia
    Santander, Colombia Santander, Colombia
    New York New York
     
     
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, Colombia Bogota, Colombia
    Retiro Antioquia. Retiro Antioquia.
     
    Colombia Colombia
     
    St Louis, MO St Louis, MO
     
    Bogotá, Colombia Bogota, Colombia
    Bogotá Bogota
    Medellín Medellin
    Medellín, Colombia Medellin, Colombia
    4.63091,-74.129868 4.63091,-74.129868
     
    Bogotá, Colombia Bogota, Colombia
     
    Colombia Colombia
    En Toda Latinoamérica.  En Toda Latinoamerica. 
    Colombia Colombia
    Medellín, Colombia Medellin, Colombia
     
    Bogotá, DC, Colombia Bogota, DC, Colombia
    Bucaramanga, COLOMBIA Bucaramanga, COLOMBIA
    Bogotá D.C. Bogota D.C.
     
    Cartagena de Indias. Cartagena de Indias.
    Colombia  Colombia 
    Cruzando el charco Cruzando el charco
    Ciudad de México Ciudad de Mexico
     
     
     
    Colombia Colombia
    El Salvador El Salvador
     
    Desde el Viejo Puerto Desde el Viejo Puerto
     
    World,Medellín World,Medellin
     
     
    Washington, DC Washington, DC
    Bogota Bogota
     
    Colombia Colombia
    Colombia  Colombia 
    New York New York
     
    Llanos Orientales Llanos Orientales
    Medellín, Colombia Medellin, Colombia
    Colombia  Colombia 
    Duluth Duluth
    Bogotá Bogota
    Medellín, Colombia Medellin, Colombia
     
    Abu Dhabi, UAE Abu Dhabi, UAE
    Colombia Colombia
    BOGOTA BOGOTA
    Barranquilla, Colombia  Barranquilla, Colombia 
    Latinoamerica y España Latinoamerica y Espana
    Latin America Latin America
    medellin medellin
     
    Colombia Colombia
    Los Angeles Los Angeles
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Santa Monica & Worldwide Santa Monica & Worldwide
     
     
    Bogotá Bogota
    Bogotá, Colombia Bogota, Colombia
    Valencia, España Valencia, Espana
    Washington D.C Washington D.C
    Seattle (via Sacramento) Seattle (via Sacramento)
    Bogotá, Colombia Bogota, Colombia
    Por todo Santander, Colombia Por todo Santander, Colombia
     
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    New York  New York 
    Bogotá Bogota
    Ciudad de México Ciudad de Mexico
    St Petersburg, Florida  St Petersburg, Florida 
    Barranquilla, Colombia Barranquilla, Colombia
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Spain Spain
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Bogota Bogota
    Tarot y TRE Tarot y TRE
    Colombia Colombia
    Miami, FL Miami, FL
    San Diego, CA San Diego, CA
    Bogotá, DC, Colombia Bogota, DC, Colombia
     
    United States United States
    Medellín, Colombia Medellin, Colombia
    Johannesburg, South Africa Johannesburg, South Africa
     
     
    La Serena, #Diaguita La Serena, #Diaguita
    Bogotá Bogota
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, Colombia Bogota, Colombia
     
    Colombia Colombia
     
    Colombia Colombia
    colombia colombia
    Argentina Argentina
    Cartagena, Colombia Cartagena, Colombia
    Bogotá Colombia Bogota Colombia
     
     
    Argentina Argentina
    Madrid Madrid
    flying around the world flying around the world
    San Francisco, CA San Francisco, CA
    secretaria@relpe.org secretaria@relpe.org
    Florida, USA Florida, USA
    Nashville, TN Nashville, TN
    Medellín Medellin
     
    Colombia Colombia
    España Espana
    New York, NY New York, NY
    Bogotá Bogota
    Colombia Colombia
    Nottingham & Norfolk Nottingham & Norfolk
    ÜT: 4.667895,-74.044464 UT: 4.667895,-74.044464
    Guayaquil Guayaquil
    Colombia Colombia
    Beyond Borders Beyond Borders
    Bogotá Bogota
     
    Bogota, Cundinamarca Colombia Bogota, Cundinamarca Colombia
    Mexico Mexico
    Kingdom of Saudi Arabia Kingdom of Saudi Arabia
     
    Bogotá, Colombia Bogota, Colombia
    Caribbean Caribbean
    Ireland & Worldwide Ireland & Worldwide
     
    Republic of Korea Republic of Korea
     
    Washington DC - Madrid Washington DC - Madrid
    Fountain Hills, Arizona Fountain Hills, Arizona
    Vancouver, Canada Vancouver, Canada
    Bogotá, Colombia Bogota, Colombia
    USA USA
    ATL ATL
    Columbus, OH Columbus, OH
    Glocal Glocal
    Pennsylvania, USA Pennsylvania, USA
     
     
    Colombia Colombia
    Orange County,  California Orange County,  California
    San Salvador San Salvador
    Guatemala Guatemala
    Baltimore, MD Baltimore, MD
    New Orleans, LA New Orleans, LA
    Nicanor Olivera. Argentina Nicanor Olivera. Argentina
     
    Medellín Medellin
    navegando.. navegando..
    Here and Now - The Present Here and Now - The Present
    Venezuela Venezuela
    Chile Chile
    BARANOA BARANOA
     
     
    Barranquilla, Colombia Barranquilla, Colombia
    NUI Maynooth, Kildare, Ireland NUI Maynooth, Kildare, Ireland
    Bogotá Bogota
     
    Latin America Latin America
    Chile Chile
    Bogota Bogota
    méxico mexico
     
    Colombia Colombia
    Cartagena Cartagena
    Lleida, Spain Lleida, Spain
    Buenos Aires, Argentina Buenos Aires, Argentina
    Bogotá Bogota
    Puerto Rico Puerto Rico
    Colombia Colombia
    Medellín, Colombia Medellin, Colombia
    Bogotá D.C. - Colombia Bogota D.C. - Colombia
    Bogotá  Bogota 
    Austin, TX Austin, TX
    Ft. Washington, MD 20744 Ft. Washington, MD 20744
    Colombia Colombia
    Buenos Aires, 🌎 Buenos Aires, 
    Cali, Colombia Cali, Colombia
     
    Medellín - Colombia Medellin - Colombia
    Buenos Aires Buenos Aires
    Bogota D.C. - Colombia Bogota D.C. - Colombia
    Florida  Florida 
     
    Mexico Mexico
    MVD, Uruguay.  MVD, Uruguay. 
    DC DC
    Colombia Colombia
    Tecleo desde un PianoBar #TFB Tecleo desde un PianoBar #TFB
    Philadelphia, PA Philadelphia, PA
    España Espana
    Washington, D.C. Washington, D.C.
    Guatemala Guatemala
     
    Medellin- Colombia Medellin- Colombia
    Sincelejo - Sucre Colombia. Sincelejo - Sucre Colombia.
    Mexico Mexico
    London London
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Santiago de Cali  Santiago de Cali 
     
    Bogota, Colombia Bogota, Colombia
    Bogotá Bogota
     
    Colombia Colombia
    Miami, FL Miami, FL
    Bogotá COLOMBIA Bogota COLOMBIA
    Famisanar Famisanar
     
    Bogotá, Colombia Bogota, Colombia
     
    Boston, Massachusetts Boston, Massachusetts
     
    Cali, Colombia Cali, Colombia
    Cali, Colombia Cali, Colombia
    Bogotá Bogota
    Costa Rica Costa Rica
    Bogotá Bogota
    COLOMBIA COLOMBIA
    Toowoomba, Queensland Toowoomba, Queensland
    Colombia Colombia
    Washington, D.C. Washington, D.C.
    Pas-de-Calais Pas-de-Calais
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    ÜT: 4.60987,-74.082 UT: 4.60987,-74.082
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Ibagué, Colombia Ibague, Colombia
     
    Miami, Fl Miami, Fl
    Venezuela y Barcelona Venezuela y Barcelona
    Bogotá Bogota
    Bogotá, CO. Bogota, CO.
     
    Bogotá, Colombia Bogota, Colombia
     
    Colombia. Colombia.
    Colombia Colombia
    Barranquilla, Colombia Barranquilla, Colombia
    Madrid, Spain Madrid, Spain
    Colombia Colombia
    Medellín - Colombia Medellin - Colombia
    Global Global
    Cali, Colombia Cali, Colombia
     
    Washington, D.C.  Washington, D.C. 
    Colombia Colombia
    MEDELLIN, COLOMBIA MEDELLIN, COLOMBIA
    Bogotá/Colombia Bogota/Colombia
     
    México, D.F.  Mexico, D.F. 
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Buenos Aires, Argentina Buenos Aires, Argentina
    Los Angeles Los Angeles
     
    Washington, DC Washington, DC
    Montelíbano, Córdoba Montelibano, Cordoba
    Bogota Bogota
    CHile CHile
     
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
     
    Barranquilla Colombia  Barranquilla Colombia 
    Bogotá Bogota
    Bogotá Bogota
    Bogotá Bogota
    Las Vegas Las Vegas
    Bogotá Bogota
    Miami - Caracas -  Bogota Miami - Caracas -  Bogota
    Bogotá Bogota
    Bogotá, Colombia Bogota, Colombia
    Bogotà D.C, Colombia Bogota D.C, Colombia
    United States United States
    Bogotá D.C. Bogota D.C.
     
    Colombia Colombia
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Bogotá, D.C; Colombia Bogota, D.C; Colombia
     
    Medellin. Colombia  Medellin. Colombia 
    México Mexico
    QUERÉTARO QUERETARO
    La Fuerza de la Independencia La Fuerza de la Independencia
    Instagram: hassannassar Instagram: hassannassar
    Bogotá, Colombia Bogota, Colombia
     
    Colombia Colombia
    Bogotá Bogota
    mexico-colombia mexico-colombia
    Medellin,Colombia Medellin,Colombia
    America America
     
    Alajuela, Costa Rica Alajuela, Costa Rica
    Washington DC Washington DC
     
    LIMA-PERU LIMA-PERU
    Medellin, Colombia Medellin, Colombia
    Bucaramanga!  Bucaramanga! 
    Ciudad del Vaticano Ciudad del Vaticano
     
     
    Washington, DC Washington, DC
    Washington, DC Washington, DC
    Washington DC Washington DC
    Now in Buenos Aires, Argentina Now in Buenos Aires, Argentina
    Bangkok Bangkok
     
     
    Argentina Argentina
    Paris Paris
    Manizales Manizales
    Madrid, Comunidad de Madrid Madrid, Comunidad de Madrid
     
     
    Bogotá Bogota
    Washington, DC Washington, DC
    Colombia Colombia
    Colombia - España Colombia - Espana
     
    Bogota, Colombia Bogota, Colombia
    Bogotá Bogota
     
    Colombia Colombia
    Exterior Exterior
     
     
    04º 38′ N, 74°05′ w 04o 38' N, 74deg05' w
    Bogotá Bogota
    washington DC washington DC
    España Espana
     
     
     
     
     
    Sao Paulo, Brasil Sao Paulo, Brasil
     
    Bogota, Colombia Bogota, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    World Citizen (MAD - CDMX) World Citizen (MAD - CDMX)
    Manhattan, NY Manhattan, NY
     🏃🏿💨  
    Latinoamérica Latinoamerica
    Washington, DC Washington, DC
    Instagram: @enghelmusica Instagram: @enghelmusica
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
     
    Florencia, Caquetá, Colombia Florencia, Caqueta, Colombia
    The World  The World 
     
    México Mexico
     
    Caracas - Venezuela Caracas - Venezuela
     
    CDMX CDMX
    Chicago, IL Chicago, IL
    Bogotá Bogota
    Bogotá, Colombia Bogota, Colombia
    Worldwide Worldwide
    PERU PERU
    Colombia Colombia
    Bogota D.C. Bogota D.C.
    Colombia Colombia
    Colombia Colombia
     
    Cartagena de Indias, Colombia Cartagena de Indias, Colombia
    Colombia Colombia
    Washington, DC Washington, DC
    Barranquilla-Cienaga Barranquilla-Cienaga
    Pereira, Colombia Pereira, Colombia
    Colombia Colombia
    ÜT: -34.595723,-58.418809 UT: -34.595723,-58.418809
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    1100 Pennsylvania Avenue,NW DC 1100 Pennsylvania Avenue,NW DC
    Medellin Medellin
    La Jolla, CA La Jolla, CA
    Colombia Colombia
     
    Bogota - Medellin Bogota - Medellin
    Brasília, Brazil Brasilia, Brazil
    New York, NY New York, NY
    usa usa
    Medellín,Colombia,Iberoamérica Medellin,Colombia,Iberoamerica
    Honduras Honduras
    valencia, spain valencia, spain
    Envigado, Colombia Envigado, Colombia
    Bucaramanga, Santander Bucaramanga, Santander
    Washington, D.C. Washington, D.C.
    Bogotá Bogota
    Frente jedi Patria Grande Frente jedi Patria Grande
     
    Colombia Colombia
    #Medellin #Medellin
    Barranquilla - Atlántico Barranquilla - Atlantico
     
     
    México Mexico
    Caracas Caracas
    México Mexico
    Barranquilla, Colombia Barranquilla, Colombia
    United States United States
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
     
    Colombia Colombia
    Colombia Colombia
    Bogotá,Colombia Bogota,Colombia
     
    Uruguay Uruguay
     
    Bogota Bogota
     
    Caldas, Antioquia, Colombia Caldas, Antioquia, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    New York, NY New York, NY
     
    Medellín, Antioquia Medellin, Antioquia
    bogotá colombia bogota colombia
    marketing  marketing 
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Barranquilla, Colombia Barranquilla, Colombia
    In my shoes In my shoes
    Colombia Colombia
     
    Washington, DC Washington, DC
    Colombia Colombia
    Global Global
    New Jersey New Jersey
     
    UK UK
     
    Online  Online 
     
    Miami, FL Miami, FL
     
    NYC NYC
     
     
     
     
    NYC & Michigan NYC & Michigan
    New York, NY New York, NY
    In transit .  In transit . 
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Cali, Colombia Cali, Colombia
    Bogotá, Colombia Bogota, Colombia
    Washington, DC Washington, DC
    Cali, Colombia Cali, Colombia
    Colombia Colombia
     
    Cali, Colombia Cali, Colombia
    NYC / SF NYC / SF
    Tufts University Tufts University
    Boston, MA Boston, MA
    New York City New York City
     
    New York, NY New York, NY
     
     
     
    London London
    UK UK
    Colombia Colombia
    Cali, Colombia Cali, Colombia
    Omaha, NE Omaha, NE
    San Diego (UCSD) San Diego (UCSD)
     
    Washington, D.C Washington, D.C
     
    Santafé de Bogotá - Colombia Santafe de Bogota - Colombia
     
    Worldwide Worldwide
    Global Global
     
    US US
     
    New York New York
     
    Stanford, CA Stanford, CA
    New York, NY New York, NY
    Cambridge, MA  Cambridge, MA 
    Montería, Córdoba. Monteria, Cordoba.
    Cali, Colombia Cali, Colombia
    Chicago & Dubai Chicago & Dubai
    Washington, D.C. Washington, D.C.
    Medellin - Colombia  Medellin - Colombia 
    Geneva Geneva
    New York, NY New York, NY
    43.301279,-2.011885 43.301279,-2.011885
    Colombia Colombia
    Bogota, Colombia Bogota, Colombia
    NOLA-Africa-Amsterdam-Austin NOLA-Africa-Amsterdam-Austin
     
    Redmond, WA Redmond, WA
    Washington, DC, USA Washington, DC, USA
    Philadelphia, USA Philadelphia, USA
    Colombia Colombia
    Austin, Texas Austin, Texas
    Round Rock TX Round Rock TX
    Medellín, Colombia Medellin, Colombia
     
    Austin, TX | Global Austin, TX | Global
    Mexico Mexico
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Atlanta & Unexpected Places Atlanta & Unexpected Places
     
     
     
    Santo Tomás (Atl.), Colombia Santo Tomas (Atl.), Colombia
    Cambridge, MA Cambridge, MA
    California California
    Providence, Rhode Island Providence, Rhode Island
    Providence, RI Providence, RI
    Rhode Island Rhode Island
    Swiss Global Citizen Swiss Global Citizen
    San Francisco San Francisco
    Austin Austin
     
    Palo Alto Palo Alto
    Oxford, UK Oxford, UK
    Global Global
    Mumbai, India Mumbai, India
    San Francisco San Francisco
     
    Palo Alto Palo Alto
    Oxford Oxford
     
    USA USA
    Dallas, TX, USA Dallas, TX, USA
    worldwide worldwide
    Denver, CO Denver, CO
    Washington, DC Washington, DC
    Arlington, VA, USA Arlington, VA, USA
    New York New York
     
    Honolulu, HI Honolulu, HI
    San Fran Austin Miami Beach San Fran Austin Miami Beach
    University of Texas at Austin University of Texas at Austin
    New York, NY New York, NY
    New York, NY New York, NY
    Austin, TX & Airports! Austin, TX & Airports!
    NYC, NY 10010 NYC, NY 10010
    New York, NY New York, NY
    Global Global
    San Mateo, CA San Mateo, CA
    Austin, TX Austin, TX
    Austin, Texas Austin, Texas
    Washington D.C. Washington D.C.
    LA | NYC | Austin  LA | NYC | Austin 
    Bogotá Bogota
    Madrid Madrid
    Medellín Medellin
     
    Washington, DC Washington, DC
    Colombia Colombia
     
    Bogotá, Colombia Bogota, Colombia
    Bogota Bogota
    Bogotá (Colombia) Bogota (Colombia)
     
    Colombia Colombia
     
    Canada Canada
     
     
    Lima, Peru Lima, Peru
    Dublin  Dublin 
    Medellín - Colombia Medellin - Colombia
    Lima, Peru Lima, Peru
    Colombia Colombia
    Argentina & Colombia Argentina & Colombia
     
     
     
     
    Palmira, Colombia Palmira, Colombia
     
     
     
    Iberoamérica & DC Iberoamerica & DC
    Bogotá-Colombia Bogota-Colombia
    Washington, DC Washington, DC
    Virginia, USA Virginia, USA
    Alemania - Colombia Alemania - Colombia
    Miami Miami
    Tunja - Boyacá - Colombia Tunja - Boyaca - Colombia
    Panama Panama
    Medellín, Colombia Medellin, Colombia
     
     
    Panama Panama
    Donmatías, Colombia Donmatias, Colombia
    Americas Americas
    ÜT: 38.898871,-77.031019 UT: 38.898871,-77.031019
    lima, peru lima, peru
    Vatican City Vatican City
    Montreal // Las Vegas Montreal // Las Vegas
    California California
    Colombia Colombia
     
     
     
    América America
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Madrid Madrid
    Colombia Colombia
    Miami Miami
    Washington, USA Washington, USA
    MEDELLÍN - COLOMBIA MEDELLIN - COLOMBIA
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    México Mexico
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    COLOMBIA COLOMBIA
    Global Global
     
    blogs.iadb.org/agua blogs.iadb.org/agua
    Washington D.C. Washington D.C.
    Barbados Barbados
    Washington, DC Washington, DC
     
    Washington D.C. Washington D.C.
     
     
    San Francisco, CA San Francisco, CA
    Canada, Moncton  Canada, Moncton 
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Washington DC Washington DC
    Seattle, WA and everyewhere... Seattle, WA and everyewhere...
    Medellín, Colombia Medellin, Colombia
     
    Delegación de Salamanca  Delegacion de Salamanca 
     
    Washington, DC Washington, DC
    Bogotá, Colombia Bogota, Colombia
    Bogotá - Colombia  Bogota - Colombia 
    Bogota D.C Bogota D.C
    Washington, D.C. Washington, D.C.
    Colombia Colombia
    Washington, D.C. Washington, D.C.
     
    Colombia Colombia
    Bogota - Colombia Bogota - Colombia
     
    New York City New York City
    Washington, DC Washington, DC
    Chocó Bioregion, Colombia Choco Bioregion, Colombia
    Medellín Medellin
    Bogota - Colombia Bogota - Colombia
    Bogota, Colombia Bogota, Colombia
    Madrid, Spain Madrid, Spain
    Colombia Colombia
    Calle 69 # 6 - 20 Bogotá Calle 69 # 6 - 20 Bogota
     
    Bogotá, Colombia. Bogota, Colombia.
     
    Bogotá Bogota
     
     
    Un ciudadano global Un ciudadano global
    Bogotá- Colombia Bogota- Colombia
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá Bogota
     
    Colombia Colombia
     
    Washington, DC and the world Washington, DC and the world
    Villafranca del Castillo  Villafranca del Castillo 
    Peru Peru
    New York, NY New York, NY
    Bogotá D.C. Bogota D.C.
    Colombia Colombia
    Villa de Antón Hero de Cepeda Villa de Anton Hero de Cepeda
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogota Bogota
     
    Bogotá Bogota
     
    New York, New York New York, New York
    NYC & DC, mostly NYC & DC, mostly
     
    Bogotá  Bogota 
     
    Colombia Colombia
    Bogota, Colombia Bogota, Colombia
    New York, NY New York, NY
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Washington DC Washington DC
     
    Caracas Caracas
    Colombia Colombia
    Stanford, CA Stanford, CA
    Bogotá Colombia  Bogota Colombia 
    Bogotá Bogota
    Medellín, Antioquia Medellin, Antioquia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
     
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Colombia Colombia
    Medellín - Colombia Medellin - Colombia
    Colombia Colombia
    BOGOTÁ, D.C. BOGOTA, D.C.
    Bogota Bogota
    Colombia Colombia
    Washington DC Washington DC
    Bogotá, Colombia. Bogota, Colombia.
    Colombia Colombia
    Colombia Colombia
    Washington DC  Washington DC 
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    DF, México DF, Mexico
     
    Arizona, USA Arizona, USA
    São Paulo Sao Paulo
    Around the world Around the world
    Washington, DC Washington, DC
     
    Bogota Colombia Bogota Colombia
    San Francisco San Francisco
    Iberoamérica Iberoamerica
     
    Bogotá, DC, Colombia Bogota, DC, Colombia
    Centro Democratico Centro Democratico
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Brasília, Brazil Brasilia, Brazil
    Washington, DC Washington, DC
     
    Mexico Mexico
    Colombia Colombia
     
     
    DC Metro Area DC Metro Area
    Medellin, Colombia Medellin, Colombia
    Bogota, Colombia Bogota, Colombia
    España Espana
    Bogotá / Cartagena - Colombia Bogota / Cartagena - Colombia
    Global Global
    Venezuela Venezuela
    Miami, Florida Miami, Florida
    Centro de la Ciudad de México Centro de la Ciudad de Mexico
     
    Colombia Colombia
     
    Bogotá, Colombia Bogota, Colombia
    Miami, FL Miami, FL
    Santo Domingo, RD Santo Domingo, RD
     
    Bogota D.C. Bogota D.C.
    Atlanta, GA Atlanta, GA
     
    Bogotá/Miami/Cloud Nine Bogota/Miami/Cloud Nine
     
    Mexico City Mexico City
    Colombia Colombia
    Williamsburg, VA Williamsburg, VA
     
     
    New York New York
    Bogota, Colombia Bogota, Colombia
    Euzkadi Euzkadi
    Lima Peru Lima Peru
    Washington DC Washington DC
     
    Miami Beach, FL Miami Beach, FL
     
    Colombia Colombia
    Montevideo, Uruguay Montevideo, Uruguay
    South Beach, FL South Beach, FL
    Toda América Latina Toda America Latina
     
    Toulouse Toulouse
    Washington, DC Washington, DC
    Washington, D.C.  Washington, D.C. 
    Washington, DC Washington, DC
    Washington, DC Washington, DC
    Washington DC Washington DC
    Washington, D.C.  Washington, D.C. 
    #Argentina #Washington DC #Argentina #Washington DC
    Boston MA and Bogotá Colombia Boston MA and Bogota Colombia
    New York, NY New York, NY
    Colombia Colombia
     
    Arlington Va Arlington Va
    New York, NY New York, NY
    Winnipeg Winnipeg
    TO & Instagram: Captain_Cammy TO & Instagram: Captain_Cammy
    Colombia Colombia
    Redmond, WA Redmond, WA
    Colombia Colombia
    Bogotá - Colombia  Bogota - Colombia 
    Bogotá D.C Bogota D.C
    Salí y ahora no puedo entrar Sali y ahora no puedo entrar
    Sto. Dgo., Rep. Dom. Sto. Dgo., Rep. Dom.
     
    Asturias Asturias
     
    Miami, FL Miami, FL
    http://goo.gl/jChGH http://goo.gl/jChGH
    Montera, 24 - Madrid (España) Montera, 24 - Madrid (Espana)
    Rio Grande do Sul Rio Grande do Sul
    América Latina America Latina
    Bogotá Bogota
    Washington, DC Washington, DC
     
    YOPAL - CASANARE YOPAL - CASANARE
    Washington, DC Washington, DC
    Washington, D.C. Washington, D.C.
    Mexico City Mexico City
     
    DC + the world DC + the world
    VA VA
    Colombia Colombia
    Doha Doha
    Vancouver, Canada Vancouver, Canada
    Macondo Macondo
    Universidad de Puerto Rico Universidad de Puerto Rico
    London London
    España Espana
    Saint-Etienne France Saint-Etienne France
    Paris Paris
    Basel, Switzerland Basel, Switzerland
    Trafalgar Square, London Trafalgar Square, London
    México Mexico
    Medellín, Colombia Medellin, Colombia
    Colombia Colombia
    New York, NY New York, NY
    Washington, D.C. Washington, D.C.
    20817 20817
    SPAIN SPAIN
    Miami, FL Miami, FL
    Winnipeg, Manitoba Winnipeg, Manitoba
    London, Liverpool and St Ives London, Liverpool and St Ives
    Philadelphia, PA 19130 Philadelphia, PA 19130
    Central Sq., Cambridge, MA USA Central Sq., Cambridge, MA USA
    New York, NY New York, NY
    Washington, DC Washington, DC
    Los Angeles, California Los Angeles, California
    New York, New York New York, New York
    London London
    New York City New York City
    Washington, DC Washington, DC
    New York City, NY, USA New York City, NY, USA
    Washington, DC Washington, DC
    Worldwide Worldwide
    Nationwide Nationwide
    Next in Vancouver BC Next in Vancouver BC
    Washington, DC + everywhere! Washington, DC + everywhere!
    Washington, D.C. Washington, D.C.
    Washington, DC Washington, DC
    Washington, D.C. Washington, D.C.
    Cartagena de Indias, Colombia Cartagena de Indias, Colombia
     
    United States United States
    Boston, Massachusetts, USA Boston, Massachusetts, USA
    Washington, DC Washington, DC
     
    White House & elsewhere White House & elsewhere
    Syria Syria
     
    Washington, DC Washington, DC
     
    Managua, Nicaragua Managua, Nicaragua
    Brooklyn, NY Brooklyn, NY
    New York, NY New York, NY
    London London
    New York New York
    United Kingdom United Kingdom
    Los Angeles Los Angeles
    Washington DC Washington DC
    New York City New York City
    London NW1 2DB London NW1 2DB
    New York, NY New York, NY
    Washington, DC Washington, DC
    Washington, DC Washington, DC
    Washington, DC Washington, DC
    London, England London, England
    Online  Online 
    Washington, DC Washington, DC
    Vienna, Austria Vienna, Austria
    Berlin, Germany Berlin, Germany
    Washington, DC Washington, DC
    USA USA
    Rome, Italy Rome, Italy
    Acapulco de Juárez, Guerrero Acapulco de Juarez, Guerrero
    Africa, Asia & Central America Africa, Asia & Central America
    AFR BRA CHN EUR IND IDN MEX USA AFR BRA CHN EUR IND IDN MEX USA
    Global Global
     
    Washington DC Washington DC
    Cali, Colombia Cali, Colombia
    Washington, DC Washington, DC
     
    LA/Sanctuary City of Angels ✨ LA/Sanctuary City of Angels 
     
    Bronx, NY Bronx, NY
    Washington, DC Washington, DC
    Washington DC Washington DC
    U.S. Department of State U.S. Department of State
    Washington, DC Washington, DC
    Washington, DC Washington, DC
     
    Cambridge, MA Cambridge, MA
    New York City New York City
    Durham, NC Durham, NC
     
    Washington, DC Washington, DC
    44 Locations Worldwide 44 Locations Worldwide
    New York, New York New York, New York
     
    Wherever permits can be pulled Wherever permits can be pulled
    Washington, D.C. Washington, D.C.
     
    Boston-NYC-SF-Europe Boston-NYC-SF-Europe
    New York, NY New York, NY
    Berkeley, CA Berkeley, CA
     
    Brooklyn,  NY Brooklyn,  NY
    New York, NY, USA New York, NY, USA
    Boston, MA Boston, MA
    Los Angeles Los Angeles
    Continente Americano Continente Americano
    Medellín, Colombia Medellin, Colombia
     
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    New York, NY New York, NY
    España Espana
    Argentina Argentina
    Asunción, Paraguay Asuncion, Paraguay
    Ecuador Ecuador
    Lima Perú Lima Peru
     
    Barranquilla Barranquilla
    Madrid, España Madrid, Espana
    Los Angeles, CA Los Angeles, CA
    New York, NY New York, NY
    New York City (usually) New York City (usually)
    France France
    Washington, D.C. Washington, D.C.
    New Haven, CT New Haven, CT
    London London
     
     
    Brasília Brasilia
    Medellín, Colombia Medellin, Colombia
    Bogotá, Colombia Bogota, Colombia
    Arlington, VA | New York, NY Arlington, VA | New York, NY
    Arlington, VA Arlington, VA
     
    Cambridge, MA Cambridge, MA
     
    madrid madrid
    Madrid, España Madrid, Espana
    Colombia Colombia
    London London
    UK UK
    Washington, DC   Washington, DC  
    iPhone: 40.751663,-73.989670 iPhone: 40.751663,-73.989670
    Washington, DC Washington, DC
    Washington, DC Washington, DC
    Cambridge, MA Cambridge, MA
    New York New York
    DC DC
    Stanford, CA Stanford, CA
    Colombia Colombia
     
    Colombia Colombia
    Mexico City Mexico City
    Bogotá Bogota
    Los Angeles Los Angeles
    Colombia Colombia
    New York, NY New York, NY
     
    Colombia Colombia
    ÜT: 34.022451,-84.259735 UT: 34.022451,-84.259735
     
     
     
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
     
    México Mexico
     
     
    Colombia Colombia
    Here & there. Proud Canadian. Here & there. Proud Canadian.
    601 Brickell Key Dr, Suite 103 601 Brickell Key Dr, Suite 103
     
    www.laotraesquina.co www.laotraesquina.co
    Panamá Panama
    Colombia Colombia
    houston, Texas houston, Texas
    Bogotá/New York Bogota/New York
    GCC GCC
    Colombia Colombia
     
    Bogota,Colombia Bogota,Colombia
     
    Miami, FL Miami, FL
    Los Angeles, CA Los Angeles, CA
    Colombia Colombia
     
    Washington, DC Washington, DC
    Global Global
    Bogotá, Colombia Bogota, Colombia
    Peru Peru
    Colombia Colombia
     
    London, UK London, UK
     
    Princeton, NJ Princeton, NJ
     
     
    New York, New York New York, New York
    Oakland, CA Oakland, CA
    Auburn, Alabama Auburn, Alabama
    New York, NY New York, NY
    New York, NY New York, NY
    Washington, DC Washington, DC
    Washington, D.C. Washington, D.C.
    Eugene, Oregon Eugene, Oregon
    London, İstanbul London, Istanbul
     
    Barcelona Barcelona
     
    Washington, D.C. Washington, D.C.
     
    Turkey Turkey
    Israel Israel
    Ankara, Turkey Ankara, Turkey
     
     
    Madrid Madrid
    Venezuela Venezuela
    México Mexico
    Washington D.C. Washington D.C.
    América/America   America/America  
    Mountain View, CA Mountain View, CA
    Harvard Business School Harvard Business School
     
    Caracas, Venezuela Caracas, Venezuela
    Geneva, Switzerland Geneva, Switzerland
    Everywhere Everywhere
    Israel Israel
    Israel Israel
    Suisse Suisse
    Cancun, Mexico Cancun, Mexico
    Global Global
    Rome, Italy Rome, Italy
    México Mexico
    The Hague, The Netherlands The Hague, The Netherlands
    London London
    Australia and around the world Australia and around the world
     
    Washington, D.C. Washington, D.C.
    Washington, DC & New York, NY Washington, DC & New York, NY
    Geneva Geneva
    New York, USA New York, USA
    Geneva Geneva
    Geneva, Switzerland Geneva, Switzerland
    New York, NY New York, NY
    En todas partes En todas partes
     
     
    Colombia Colombia
    Washington, DC Washington, DC
    Miami, FL Miami, FL
     
    Bogotá, Colombia Bogota, Colombia
    Global Global
    Colombia Colombia
    Colombia  & USA Colombia  & USA
     
    Boston, MA Boston, MA
    Boston, MA Boston, MA
    Singapore Singapore
    Washington Washington
    New York, NY New York, NY
    Chile Chile
    Cuentas claras, cuentas sanas. Cuentas claras, cuentas sanas.
    AA, Avianca, LATAM, United, BA.... AA, Avianca, LATAM, United, BA....
    Pittsburgh, PA Pittsburgh, PA
    Worldwide Worldwide
    170 countries & territories 170 countries & territories
    Washington, DC Washington, DC
    Washington, DC, USA Washington, DC, USA
    Chicago Chicago
    New York, New York New York, New York
    Cambridge, MA US Cambridge, MA US
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá Bogota
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Los Angeles, California Los Angeles, California
    Tucson, AZ Tucson, AZ
    Dublin, Ireland Dublin, Ireland
     
     
    Ireland Ireland
    Washington, DC Washington, DC
    London London
    Saint Helena, Ascension and Tr Saint Helena, Ascension and Tr
    Worldwide Worldwide
    Delivering your photos Delivering your photos
    Newport Beach, California Newport Beach, California
    Berkeley, California Berkeley, California
    Global Global
     Washington, D.C.  Washington, D.C.
     
    London London
    Washington Washington
    London, United Kingdom London, United Kingdom
    Washington, DC Washington, DC
    angrybearblog.com angrybearblog.com
    Miami Miami
     
    New York New York
    New York New York
    Africa, Asia, Europe, Americas Africa, Asia, Europe, Americas
    Toronto, Ontario Toronto, Ontario
    Los Angeles, CA Los Angeles, CA
     
    Mill Valley, CA Mill Valley, CA
    NYC - Boston - Chicago - SF NYC - Boston - Chicago - SF
    Palo Alto, CA Palo Alto, CA
    Half Moon Bay, California, USA Half Moon Bay, California, USA
    Petaluma, CA Petaluma, CA
    London, UK London, UK
    Washington, DC Washington, DC
     
    Washington, D.C. Washington, D.C.
    Global Global
     
    ÜT: 4.676608,-74.040679 UT: 4.676608,-74.040679
    Bristol, UK Bristol, UK
     
    Geneva, Switzerland Geneva, Switzerland
    Switzerland Switzerland
     
    San Francisco, California San Francisco, California
    New York New York
    New York, London, Singapore New York, London, Singapore
    Bogota Bogota
     
    Colombia Colombia
    Washington, D.C. Washington, D.C.
    Columbia University, New York Columbia University, New York
    Washington, DC Washington, DC
    New York, NY New York, NY
     
    Princeton University Princeton University
    Washington, DC Washington, DC
     
    Connecticut Connecticut
    Stanford, CA Stanford, CA
    Washington, DC Washington, DC
    Dharamsala, India Dharamsala, India
    Los Angeles, California Los Angeles, California
    London, New York, Hong Kong London, New York, Hong Kong
    Toronto, Canada Toronto, Canada
     
    Global Global
    San Francisco, CA San Francisco, CA
     
     
     
    Geneva, Switzerland Geneva, Switzerland
    United Nations United Nations
    London London
     
    London London
    London London
    Washington, DC Washington, DC
    London, New York, Hong Kong London, New York, Hong Kong
    New York, NY New York, NY
    Dublin, Ireland Dublin, Ireland
    Washington, DC Washington, DC
     
    London, UK London, UK
    New York, NY New York, NY
    New York, NY New York, NY
    Washington, DC Washington, DC
    Paris, France Paris, France
     
    Berkeley, CA Berkeley, CA
    New York · TrendsJournal.com New York * TrendsJournal.com
    New York City, USA New York City, USA
    Basel, Switzerland Basel, Switzerland
    New York  New York 
    Stockholm, Sweden Stockholm, Sweden
    Princeton, NJ Princeton, NJ
    Charlottesville, Va. Charlottesville, Va.
    New York, NY New York, NY
    New York, NY New York, NY
    Washington, D.C. Washington, D.C.
    London London
    [unofficial account] [unofficial account]
    New York City New York City
    New York, NY New York, NY
     
    San Bruno, CA San Bruno, CA
    New York, NY New York, NY
    New York New York
    New York, NY New York, NY
    New York New York
    Global Global
    Oxford Oxford
    Washington, DC Washington, DC
    Maryland Maryland
    New York, NY New York, NY
    Los Angeles Los Angeles
     
    Bogota-Colombia Bogota-Colombia
    London, UK London, UK
    London, UK London, UK
    New York, NY New York, NY
    San Francisco, California San Francisco, California
    San Francisco, CA San Francisco, CA
    New York and the World New York and the World
    Global Global
    Appian Way, Cambridge, Mass Appian Way, Cambridge, Mass
    Boston, MA Boston, MA
    Colombia Colombia
    Our World ☮ Our World 
    New York, NY New York, NY
    Toronto Toronto
    New York, NY New York, NY
    New York New York
    Asbury Park, NJ Asbury Park, NJ
    New York, NY New York, NY
    United States of America United States of America
    Washington, D.C. Washington, D.C.
    Washington, D.C. Washington, D.C.
    Washington, DC Washington, DC
    Washington, DC Washington, DC
    Phoenix, AZ / Washington, DC Phoenix, AZ / Washington, DC
    Dubai, UAE Dubai, UAE
    Arlington, Va. Arlington, Va.
     
     
    Washington, DC  Washington, DC 
    Everywhere Everywhere
    10 Downing Street, London 10 Downing Street, London
    New York, NY New York, NY
    Nashville, TN Nashville, TN
    New York, NY USA New York, NY USA
    Washington, DC Washington, DC
    Washington, D.C. Washington, D.C.
    New Delhi & Thiruvananthapuram New Delhi & Thiruvananthapuram
    New York New York
    United States United States
     
     
    New York City New York City
    New York, New York New York, New York
    New York City New York City
    San Francisco San Francisco
     
    Cambridge, MA Cambridge, MA
    Berkeley, CA Berkeley, CA
    Colombia Colombia
    Alaska Alaska
    Colombia Colombia
    Washington D.C. Washington D.C.
     
    Washington, DC Washington, DC
     
    Berkeley, CA Berkeley, CA
    Cambridge, MA Cambridge, MA
    Ithaca, New York Ithaca, New York
    Princeton, NJ Princeton, NJ
    Philadelphia, PA Philadelphia, PA
    Stanford, CA Stanford, CA
    Cambridge, MA, USA Cambridge, MA, USA
    Boston, MA USA Boston, MA USA
    Stanford University Stanford University
    Medford, MA Medford, MA
    Washington, DC Washington, DC
    Stanford, CA Stanford, CA
    Miami, FL Miami, FL
    Boston, MA Boston, MA
    Seattle, Washington Seattle, Washington
    Washington, DC Washington, DC
    New York City New York City
    Washington, D.C. Washington, D.C.
    Washington, DC Washington, DC
    London London
     
    New York City New York City
    Everywhere! Everywhere!
    Worldwide Worldwide
     
    Global Global
    Africa Africa
    Wherever Wherever
    Washington, D.C. - USA Washington, D.C. - USA
    Cambridge, MA Cambridge, MA
    New York, NY New York, NY
    Everywhere Everywhere
    30,000 feet up in the air 30,000 feet up in the air
    Michigan/New York City Michigan/New York City
    Colombia Colombia
    Washington, DC Washington, DC
    Washington, DC Washington, DC
    Bogotá Bogota
    Bogota Bogota
    Bogotá, Colombia Bogota, Colombia
     
    ÜT: 4.707552,-74.050778 UT: 4.707552,-74.050778
    Barranquilla, Colombia Barranquilla, Colombia
    Atlanta, GA Atlanta, GA
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá D.C Bogota D.C
    Bogotá, Colombia Bogota, Colombia
     
    Colombia Colombia
     
    Bogotá, Colombia Bogota, Colombia
    Ibagué, Tolima Ibague, Tolima
    Bogota, Colombia Bogota, Colombia
    Cúcuta, Colombia Cucuta, Colombia
    Cúcuta Cucuta
    Bucaramanga, Santander Bucaramanga, Santander
    Bucaramanga Bucaramanga
    Bucaramanga Bucaramanga
    Villeta, Colombia Villeta, Colombia
    Bogotá, Colombia Bogota, Colombia
     
    Santa Marta, Colombia Santa Marta, Colombia
    Montería - Colombia Monteria - Colombia
    Córdoba, Colombia Cordoba, Colombia
    Pereira - Colombia Pereira - Colombia
    cali cali
    Caldas - Quindío - Risaralda Caldas - Quindio - Risaralda
    Manizales, Colombia Manizales, Colombia
    Pereira, Colombia Pereira, Colombia
     
    Pereira, Colombia Pereira, Colombia
    Manizales Manizales
     
    Manizales, Colombia Manizales, Colombia
    ÜT: 34.022451,-84.259735 UT: 34.022451,-84.259735
    Instagram: hassannassar Instagram: hassannassar
    Bogotá, Colombia Bogota, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá COLOMBIA Bogota COLOMBIA
     
    Cali Colombia Cali Colombia
    Cali, Colombia Cali, Colombia
    Cali, Valle. Colombia Cali, Valle. Colombia
    Cali, Colombia Cali, Colombia
    Colombia Colombia
    Cali, Colombia Cali, Colombia
     
    Bogotá, Colombia. Bogota, Colombia.
    Bogotá - Colombia Bogota - Colombia
    Colombia Colombia
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Barranquilla, Colombia Barranquilla, Colombia
    Colombia Colombia
    Montevideo, Uruguay Montevideo, Uruguay
    Bogota, Colombia Bogota, Colombia
     
    Colombia Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá, Colombia. Bogota, Colombia.
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Pereira Pereira
    Colombia Colombia
    Colombia Colombia
    ÜT: 4.650541,-74.074043 UT: 4.650541,-74.074043
    Valledupar - Cesar Valledupar - Cesar
    Medellín, Antioquia Medellin, Antioquia
    Bogotá D.C. Bogota D.C.
    Colombia Colombia
     
    Colombia Colombia
    Honduras Honduras
    Bogotá Bogota
     
    Colombia Colombia
     Carabobo-Venezuela   Carabobo-Venezuela 
    London London
     
     
    Tunja, Boyaca Tunja, Boyaca
    Colombia Colombia
    Guatemala, Centroamérica Guatemala, Centroamerica
    New York New York
     
    Bogotá, DC, Colombia Bogota, DC, Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogota Colombia Bogota Colombia
    Colombia Colombia
    Cucuta Colombia  Cucuta Colombia 
    Colombia Colombia
    San Andrés, Colombia San Andres, Colombia
    Colombia Colombia
    Colombia Colombia
    Washington, DC Washington, DC
    Boyacá, Colombia Boyaca, Colombia
    Bogota - Colombia Bogota - Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    France France
    Cali, Colombia Cali, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Ecuador Ecuador
    Bogotá Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Washington, D.C. Washington, D.C.
    Purchase, NY Purchase, NY
    Atlanta, Georgia, USA Atlanta, Georgia, USA
     
     
    Puerto la Cruz-Venezuela  Puerto la Cruz-Venezuela 
    Manizales, Caldas Manizales, Caldas
    Manizales Manizales
     
    Manizales, Caldas, Colombia. Manizales, Caldas, Colombia.
    Manizales, Caldas Manizales, Caldas
    Washington, DC, USA Washington, DC, USA
    Washington, D.C. Washington, D.C.
     
     
    BOGOTA BOGOTA
     
    Bogotá, Colombia. Bogota, Colombia.
    América Latina America Latina
     
    Ecuador Ecuador
    Bogotá - Colombia Bogota - Colombia
     
    Colombia (Armenia, Quindío) Colombia (Armenia, Quindio)
     
    Barrancabermeja, Santander Barrancabermeja, Santander
    Washington, DC Washington, DC
     
     
    Ibague (Tolima) Ibague (Tolima)
    Ft Lauderdale Ft Lauderdale
     
     
    Colombia  Colombia 
     
     
    Caribe, Colombia Caribe, Colombia
    Perú Peru
    Bogotá Bogota
    Colombia Colombia
     
     
    Global Global
    Antioquia, Colombia Antioquia, Colombia
    Bogotá, Colombia Bogota, Colombia
    Barranquilla, Colombia Barranquilla, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Norway Norway
    Geneva, Switzerland Geneva, Switzerland
    Hordaland, Bergen Hordaland, Bergen
    Oslo Oslo
    Colombia Colombia
    Brasília Brasilia
     
    bogotá, colombia bogota, colombia
    Washington, DC Washington, DC
    Florida, USA Florida, USA
    Bogotá, D. C., Colombia Bogota, D. C., Colombia
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Medellin, Colombia Medellin, Colombia
    Turrialba, Costa Rica Turrialba, Costa Rica
     
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Panamá Panama
     
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá Colombia Bogota Colombia
    Mansion House Mansion House
     
    United Kingdom United Kingdom
    Montería, Colombia. Monteria, Colombia.
    colombia colombia
    Santiago, Chile Santiago, Chile
     
    República de Panamá Republica de Panama
    Norway Norway
    Colombia Colombia
     
    Colombia Colombia
     
     
    Bogotá, Colombia Bogota, Colombia
    Medellín, Antioquia Medellin, Antioquia
    Bogotá, Colombia Bogota, Colombia
    Bogotá Bogota
    Bogotá Bogota
     
     
    Bogota, Colombia Bogota, Colombia
    Colombia Colombia
    Sao Paulo, Brazil Sao Paulo, Brazil
    Cali, Valle Cali, Valle
    Buenaventura, Colombia Buenaventura, Colombia
    Bogota
     Bogota
    
    Colombia Colombia
    MEDELLÍN - COLOMBIA MEDELLIN - COLOMBIA
    Venezuela-Colombia-Miami Venezuela-Colombia-Miami
    Washington, D.C. Washington, D.C.
    Washington, DC Washington, DC
    Bogotá Bogota
    Colombia Colombia
    Quibdó Chocó Colombia Quibdo Choco Colombia
    Ottawa-Gatineau Ottawa-Gatineau
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia  Colombia 
    Washington, DC Washington, DC
    Colombia Colombia
    Bogotá - Colombia Bogota - Colombia
     
     
    www.worldbank.org  www.worldbank.org 
    Colombia Colombia
     
    Colombia Colombia
    Bogotá Bogota
    Columbia University, New York Columbia University, New York
    ÜT: 4.59517,-74.077369u UT: 4.59517,-74.077369u
     
    Barranquilla, Colombia Barranquilla, Colombia
     
    Paris-Le Bourget Paris-Le Bourget
     
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogota, Colombia Bogota, Colombia
     
    Bogotá D.C. Bogota D.C.
    Colombia Colombia
    Colombia Colombia
    Bogotá Bogota
    Bogotá, Colombia Bogota, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Cúcuta, Colombia Cucuta, Colombia
    Las Américas Las Americas
    Barcelona, Spain Barcelona, Spain
    Madrid Madrid
    Madrid, Comunidad de Madrid Madrid, Comunidad de Madrid
    Spain Spain
    Madrid Madrid
    Londres, Inglaterra. Londres, Inglaterra.
    América Latina America Latina
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Litoral Pacífico Colombiano Litoral Pacifico Colombiano
    Colombia Colombia
     
    BOGOTA.D.C. BOGOTA.D.C.
    Universo Universo
    Valledupar, Colombia Valledupar, Colombia
     
    Bogotà, Colombia Bogota, Colombia
    New York New York
    Madrid Madrid
    Colombia Colombia
     
    France France
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá, Colombia Bogota, Colombia
     
    Montevideo, Uruguay Montevideo, Uruguay
    Lawrence, KS Lawrence, KS
    Washington, DC Washington, DC
    New York, Washington DC, Miami New York, Washington DC, Miami
    PERU PERU
     
    Bogotá D.C. Bogota D.C.
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Geneva, Switzerland Geneva, Switzerland
    Bogotá Bogota
     
    Colombia Colombia
     
    Bucaramanga, Santander Bucaramanga, Santander
    Colombia Colombia
    Colombia Colombia
    COLOMBIA COLOMBIA
    Colombia Colombia
     
    Medellín, Colombia Medellin, Colombia
    Villavicencio-Meta-Col Villavicencio-Meta-Col
    Colombia Colombia
     
     
     
     
     
     
    Medellin (antioquia) Medellin (antioquia)
    Bogotá, Colombia. Bogota, Colombia.
    Bogotá  Bogota 
    Sahagún - Córdoba Sahagun - Cordoba
     
     
    Barranquilla, Colombia Barranquilla, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
     
    COLOMBIA  COLOMBIA 
     
    Colombia Colombia
     
    Bogotá Bogota
     
    Colombia Colombia
     
     
     
     
    Colombia Colombia
     
     
    Seattle, WA Seattle, WA
    Colombia Colombia
     
    Bogotá Bogota
    Bogotá D.C Bogota D.C
     
    Cali, Colombia Cali, Colombia
    colombia colombia
     
    Colombia Colombia
     
     
    Colombia Colombia
    Turin, Piedmont Turin, Piedmont
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Platós de A3 Platos de A3
     
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Bogotà Bogota
    Colombia Colombia
     
    Suisse Suisse
     
    Maricelamarulandamanager.com Maricelamarulandamanager.com
    Bogotá, Colombia Bogota, Colombia
    Depends on the day! Depends on the day!
    Dublin, IRE Dublin, IRE
    Washington, DC Washington, DC
    USA USA
    Bogotá Bogota
    México y Buenos Aires  Mexico y Buenos Aires 
    COL-USA COL-USA
    Puerto Rico / Argentina Puerto Rico / Argentina
    Bogotá, Colombia Bogota, Colombia
    colombia colombia
    Bogota colombia Bogota colombia
    Bogotá Bogota
     
    Bogota, Colombia  Bogota, Colombia 
    ÜT: 4.615246,-74.066386 UT: 4.615246,-74.066386
    Perú Peru
     
     
     
    California, USA California, USA
    Los Angeles Los Angeles
    Los Angeles  Los Angeles 
    Glendale, CA Glendale, CA
    Menlo Park, California Menlo Park, California
    California California
    Beverly Hills, CA Beverly Hills, CA
    Burbank, CA Burbank, CA
    New York, NY New York, NY
    Los Angeles Los Angeles
    Los Angeles, CA Los Angeles, CA
    Cannes, France Cannes, France
    ANTI ANTI
    here and there here and there
    Los Angeles, California Los Angeles, California
     
    San Francisco, CA San Francisco, CA
     
    Sunnyvale, CA Sunnyvale, CA
    Los Angeles, California Los Angeles, California
    New York, NY New York, NY
     
    Worldwide! Worldwide!
    Los Angeles, CA Los Angeles, CA
    SEA via NYC SEA via NYC
    Los Angeles Los Angeles
    Mountain View, California Mountain View, California
    Los Angeles, CA Los Angeles, CA
    New York, New York New York, New York
    Los Angeles Los Angeles
    London London
    London London
    New York, NY New York, NY
     
    Washington, DC Washington, DC
    New York and London New York and London
    London London
    Washington, D.C. Washington, D.C.
    Cupertino Cupertino
    Washington, D.C. Washington, D.C.
    Washington, DC Washington, DC
    New York, NY New York, NY
     
    Santa Fe, NM Santa Fe, NM
    Mendham, NJ Mendham, NJ
     
    Bowling Green, KY Bowling Green, KY
    New York New York
    The WORLD  The WORLD 
     
    Washington, DC Washington, DC
    GLOBAL GLOBAL
    Madrid, Spain Madrid, Spain
    Argentina Argentina
    Colombia Colombia
    CUENCA CUENCA
    Caracas, Venezuela Caracas, Venezuela
    Cali - Valle del Cauca Cali - Valle del Cauca
    Bogotá Bogota
    España Espana
    Guayaquil Guayaquil
    Maturin Monagas Maturin Monagas
    Bogota Bogota
    Pamplona (Navarra, España) Pamplona (Navarra, Espana)
    Madrid - Spain Madrid - Spain
    Murcia Murcia
    Miranda, Venezuela Miranda, Venezuela
    Panamá Panama
    Bogotá/Colombia Bogota/Colombia
    Colombia Colombia
    Panamá Panama
    CARACAS-MARACAIBO CARACAS-MARACAIBO
    Alcobendas (Madrid, España) Alcobendas (Madrid, Espana)
     
    Madrid Madrid
     
    Caracas, Venezuela. Caracas, Venezuela.
    México Mexico
    México Mexico
    Madrid Madrid
    Málaga Malaga
    Valencia-España Valencia-Espana
    Córdoba, Argentina Cordoba, Argentina
    Bogotá Colombia Bogota Colombia
    Querétaro, México Queretaro, Mexico
    Caracas-Venezuela Caracas-Venezuela
    Isla de Margarita. Venezuela Isla de Margarita. Venezuela
    Chile Chile
    Brunete, Madrid, España Brunete, Madrid, Espana
    Caracas Caracas
    México Mexico
    Santo Domingo, Rep. Dominicana Santo Domingo, Rep. Dominicana
    Colombia,Bogota Colombia,Bogota
    México, D.F. Mexico, D.F.
    España Espana
    bogota colombia bogota colombia
    Villavicencio, Colombia Villavicencio, Colombia
    madrid madrid
    Barcelona-Madrid-World Barcelona-Madrid-World
    Miami Beach, FL Miami Beach, FL
    Madrid Madrid
    Blog Blog
    España Espana
    Madrid (Spain) Madrid (Spain)
    London UK London UK
    Asturias - Madrid - España  Asturias - Madrid - Espana 
    #Asturias #Madrid #España #Asturias #Madrid #Espana
    Madrid Madrid
    Madrid, Sevilla y Elche Madrid, Sevilla y Elche
    Washington, DC      Madrid Washington, DC      Madrid
    Madrid, Spain Madrid, Spain
    España Liberal y Progresista Espana Liberal y Progresista
    A Coruña A Coruna
    Madrid Madrid
    Periodista. Mediaset.  Periodista. Mediaset. 
    En Madrid, Miami y Latam. En Madrid, Miami y Latam.
    madrid madrid
    Lima, Peru Lima, Peru
    Madrid Madrid
    Bogotá Colombia  Bogota Colombia 
    Caracas, Venezuela Caracas, Venezuela
    Almonte, Spain Almonte, Spain
    Bogotá - Colombia Bogota - Colombia
    Sevilla Sevilla
    Madrid, Comunidad de Madrid Madrid, Comunidad de Madrid
    Santiago de Chile Santiago de Chile
    Naples, Florida, USA Naples, Florida, USA
    Orlando, FL Orlando, FL
    Ann Arbor, MI Ann Arbor, MI
    San Diego, California San Diego, California
    Half Moon Bay, California, USA Half Moon Bay, California, USA
    New York, NY New York, NY
    NYC NYC
    Silicon Valley, California Silicon Valley, California
    Boston, MA Boston, MA
    Boston, Massachusetts Boston, Massachusetts
    San Francisco, California San Francisco, California
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Anywhere | Everywhere Anywhere | Everywhere
    London, England London, England
    Colombia Colombia
    Bogotá Bogota
    Washington, D.C. Washington, D.C.
    políticamente correcto politicamente correcto
    New York New York
     
     
    London, England London, England
    Cartagena de Indias, Colombia Cartagena de Indias, Colombia
    Everywhere Everywhere
     
    Madrid Madrid
    wlpress@jabber.ccc.de wlpress@jabber.ccc.de
    Washington Bureau Washington Bureau
    Bogotá, Colombia. Bogota, Colombia.
    Washington, D.C. Washington, D.C.
    Bogotá
     Bogota
    
    Washington, D.C. Washington, D.C.
    Washington, DC Washington, DC
    Bogotá, D.C  Bogota, D.C 
    Washington, DC Washington, DC
    Caracas Caracas
    BOGOTA COLOMBIA BOGOTA COLOMBIA
    New York, NY New York, NY
    Colombia Colombia
     
    Colombia Colombia
    Contacto: PUBLICIDADyC0NTACT0@outlook.com Contacto: PUBLICIDADyC0NTACT0@outlook.com
    Washington, DC Washington, DC
    in London but travelling often in London but travelling often
     
    Bogotá, Colombia Bogota, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá Bogota
    New York, NY New York, NY
    London London
    España Espana
    Washington D.C. Washington D.C.
    Colombia Colombia
     
    New York City New York City
     
    Porto Alegre.RS.Brasil. Porto Alegre.RS.Brasil.
    Rio de Janeiro Rio de Janeiro
    Bogota- Colombia Bogota- Colombia
    Colombia Colombia
    Global Global
    Chiapas México Chiapas Mexico
    30,000 feet up in the air 30,000 feet up in the air
    Yucatán, México Yucatan, Mexico
    Los Angeles / Mexico City Los Angeles / Mexico City
    Barranquilla, Colombia Barranquilla, Colombia
    New York City New York City
    Beautiful New York City Beautiful New York City
    Seattle, WA Seattle, WA
    Pacifica, CA Pacifica, CA
    Vic (68 km from Barcelona) Vic (68 km from Barcelona)
    Colombia Colombia
    Bogotá Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Bogotá D.C., Colombia Bogota D.C., Colombia
    BOGOTÁ BOGOTA
    Bogota Bogota
    Bogotá (Colombia) Bogota (Colombia)
    Bogotá, Colombia Bogota, Colombia
    Cali Cali
     
    ÜT: 4.624224,-74.069198 UT: 4.624224,-74.069198
    COLOMBIA COLOMBIA
    México Mexico
    Bogota Bogota
     
     
     
     
    Santo Domingo, RD Santo Domingo, RD
     
    Los Angeles, CA Los Angeles, CA
    Argentina Argentina
    America del sur! Colombia.  America del sur! Colombia. 
    San Francisco, CA  San Francisco, CA 
    San Juan, Puerto Rico San Juan, Puerto Rico
    México Mexico
    Madrid, España Madrid, Espana
    Madrid, España Madrid, Espana
    Bogotá Bogota
    Colombia Colombia
    NEVERLAND NEVERLAND
     
    From All Over! From All Over!
    Bogotá - Colombia Bogota - Colombia
     
    Bogota Colombia Bogota Colombia
    Bogota Bogota
    Actriz Actriz
    Bogota Bogota
     
    Miami, FL Miami, FL
    colombia colombia
    mexico df mexico df
     
    Bogota Bogota
    Bogotá,Colombia Bogota,Colombia
    Colombia Colombia
    alejo_estrada@hotmail.com alejo_estrada@hotmail.com
    Bogota, Colombia  Bogota, Colombia 
    Bogota Bogota
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Bogotá Bogota
    Bogotá Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá Bogota
    Colombia Colombia
    miami,FL  miami,FL 
    Bogotá d.c Bogota d.c
    Colombia Colombia
    Bogota, Colombia Bogota, Colombia
    Bogotá - Colombia Bogota - Colombia
     
    Colombia Colombia
    Bogota, Colombia Bogota, Colombia
     
    Colombia Colombia
     
    Medellin-Colombia Medellin-Colombia
     
    Bogota-Colombia Bogota-Colombia
    santiagombmx@gmail.com  santiagombmx@gmail.com 
     
    Bogota - Colombia Bogota - Colombia
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Colombia Colombia
     
    Washington, DC Washington, DC
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá - Colombia Bogota - Colombia
    Caracas, Venezuela Caracas, Venezuela
    Barcelona Barcelona
    Bogotá, Colombia Bogota, Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá, Colombia. Bogota, Colombia.
    Bogota, Colombia Bogota, Colombia
    Colombia Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Colombia Colombia
    Itagui, Antioquia Itagui, Antioquia
    Colombia Colombia
    Cali- Colombia Cali- Colombia
    Medellín  |  Colombia Medellin  |  Colombia
    Colombia Colombia
     
    #RompeLaRutina #RompeLaRutina
    Bogotá - Colombia Bogota - Colombia
    Colombia Colombia
    Carakistán, por ahora Carakistan, por ahora
    Distrito Federal, México Distrito Federal, Mexico
     
    Colombia Colombia
    En la olla En la olla
    Colombia Colombia
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    California California
    New York, NY New York, NY
    Paris, France Paris, France
    San Francisco, CA San Francisco, CA
    Chicago Chicago
    San Francisco San Francisco
    NYC/LA/SF/DC NYC/LA/SF/DC
    MA but grew up in Cali MA but grew up in Cali
    North Carolina North Carolina
     
    SF / LA / NYC SF / LA / NYC
     
    Brooklyn, NY Brooklyn, NY
    Dogpatch Dogpatch
    Beaverton, Oregon Beaverton, Oregon
    San Francisco San Francisco
    Hong Kong Hong Kong
     
    Washington, D.C. Washington, D.C.
    San Francisco, CA San Francisco, CA
    SF / NY / SIN SF / NY / SIN
    San Francisco, CA San Francisco, CA
    Marin, California Marin, California
    San Francisco, CA San Francisco, CA
    NYC NYC
    London, England London, England
     
    Hong Kong Hong Kong
     
    San Francisco San Francisco
    San Francisco San Francisco
    Los Angeles Los Angeles
    San Francisco San Francisco
     
    Newtown CT Newtown CT
    New York New York
     
    roya@digitalcitizenfund.org roya@digitalcitizenfund.org
    Southampton, NY Southampton, NY
    National. National.
    San Francisco & Marin San Francisco & Marin
     
    Here. Here.
    The Bay Area The Bay Area
    San Francisco San Francisco
    Santa Barbara, California, USA Santa Barbara, California, USA
     
    San Francisco, CA San Francisco, CA
    Omaha, NE Omaha, NE
    Bassano del Grappa Bassano del Grappa
    New York City New York City
    Brasil Brasil
    UE-EEUU UE-EEUU
    Venezuela Venezuela
    Monterrey, México. Monterrey, Mexico.
    Ciudad de México Ciudad de Mexico
    Mexico City Mexico City
     
    Various  Various 
    Quito - Ecuador Quito - Ecuador
    Estados Unidos Estados Unidos
    NY NY
    Palacio de Ciliaflores Palacio de Ciliaflores
    Washington, DC Washington, DC
    Colombia Colombia
    Colombia Colombia
    Carrera 13 No. 54-74  Carrera 13 No. 54-74 
    Colombia Colombia
    Washington, D.C. Washington, D.C.
    Los Angeles, California Los Angeles, California
    Boston, MA | Everywhere Boston, MA | Everywhere
    Colombia Colombia
    Armenia Armenia
    Worldwide Worldwide
     
    Bogotá Bogota
    Colombia Colombia
     
     
    Página Oficial: Pagina Oficial:
     
    Colombia Colombia
    Miami, Florida Miami, Florida
    Medellín, Colombia Medellin, Colombia
    Santo Domingo, R.D. Santo Domingo, R.D.
    Miami, Florida Miami, Florida
    MIAMI - BOGOTA - MEDELLIN MIAMI - BOGOTA - MEDELLIN
     
    Miami, FL Miami, FL
    Washington, D.C. Washington, D.C.
    New York, NY New York, NY
     
    Washington, DC Washington, DC
    Dhaka, Bangladesh Dhaka, Bangladesh
     
    New York, USA New York, USA
    Mountain View, CA Mountain View, CA
    Bogotá Bogota
     
     
    New York, NY New York, NY
    Cuba Cuba
    America Latina America Latina
    Mendoza, Argentina Mendoza, Argentina
     
    Torino, Piemonte Torino, Piemonte
    Manchester Manchester
    Bogotá, Colombia Bogota, Colombia
    Medellín - Colombia Medellin - Colombia
    New York New York
    Washington, DC Washington, DC
    Global Global
    Ciudad de Mexico Ciudad de Mexico
    Washington, DC Washington, DC
    New York, NY New York, NY
    Worldwide Worldwide
    Washington D.C. Washington D.C.
    Atlanta, GA Atlanta, GA
     
    Atlanta, GA Atlanta, GA
    Washington DC Washington DC
    Atlanta y Latinoamérica Atlanta y Latinoamerica
    Miami - Maracay ❤️ Miami - Maracay [?]
    Atlanta Atlanta
     
     
    London, England London, England
    United States United States
     
    Washington Washington
    Washington, DC Washington, DC
    Contacto: PUBLICIDADyC0NTACT0@outlook.com Contacto: PUBLICIDADyC0NTACT0@outlook.com
    Instagram: @AMAs Instagram: @AMAs
     
    Bogota Bogota
    Twitter HQ Twitter HQ
    Cupertino, CA Cupertino, CA
    Spain Spain
     
    Puerto Rico Puerto Rico
     
     
    WORLDWIDE WORLDWIDE
     
    Emmaus, PA Emmaus, PA
    Instagram: @menshealthmag Instagram: @menshealthmag
    Ciudad de Washington Ciudad de Washington
    Bogota D.C. Bogota D.C.
    Genovia Genovia
    New York, NY New York, NY
    Rionegro, Antioquia Rionegro, Antioquia
    San Francisco San Francisco
    Washington, D.C. Washington, D.C.
    Washington, D.C. Washington, D.C.
    Washington, D.C. Washington, D.C.
    Washington, DC Washington, DC
    New York, NY New York, NY
    New York New York
    120 countries 120 countries
    Geneva Geneva
    Washington, DC Washington, DC
    Georgia, USA Georgia, USA
    Atlanta, GA Atlanta, GA
    Bogotá, Colombia Bogota, Colombia
     
    New York, NY New York, NY
    Distrito Federal, México Distrito Federal, Mexico
    España Espana
    Bogotá - Colombia Bogota - Colombia
    ÜT: 25.823566,-80.131179 UT: 25.823566,-80.131179
    New York New York
    Across the globe Across the globe
    Colombia Colombia
    México-Colombia Mexico-Colombia
    Cali, Colombia Cali, Colombia
    Universidad de los Andes Universidad de los Andes
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Mexico City Mexico City
    Bogotá, Colombia Bogota, Colombia
    Chia, Cundinamarca Chia, Cundinamarca
    COLOMBIA COLOMBIA
    Seattle, WA Seattle, WA
    Colombia Colombia
    Bogotá Bogota
    Colombia Colombia
    Everywhere Mothers Are Everywhere Mothers Are
    New York, NY New York, NY
    Cambridge, Mass. Cambridge, Mass.
     
    Brighton, UK Brighton, UK
    Aberdeen, Scotland Aberdeen, Scotland
    Kingston, ON Canada Kingston, ON Canada
    Princeton, NJ Princeton, NJ
     
    Oxford, UK Oxford, UK
    New Haven, CT New Haven, CT
    Stanford, Calif. Stanford, Calif.
    Chicago, Illinois Chicago, Illinois
    Geneva, Switzerland Geneva, Switzerland
    Miami, FL Miami, FL
     
     
    Stevenage - England Stevenage - England
    Chilam Balam, Niuyol, Ventosa Chilam Balam, Niuyol, Ventosa
    México DF Mexico DF
    LA / NY LA / NY
     
    Los Angeles, CA Los Angeles, CA
     
    México y todo el mundo Mexico y todo el mundo
    América Latina America Latina
     
    Atenas Suramericana Atenas Suramericana
    En otra dimensión En otra dimension
    ÜT: 4.2119656,-74.6848978 UT: 4.2119656,-74.6848978
    Venezuela Venezuela
    Venezuela Venezuela
    Colombia Colombia
    Panamá Panama
    Washington, DC Washington, DC
    Cambridge, MA Cambridge, MA
    Cambridge, MA Cambridge, MA
    Berkeley, California Berkeley, California
    Bogota, Colombia Bogota, Colombia
     
    Latinoamérica Latinoamerica
    Medellín, Colombia Medellin, Colombia
    Miami, FL Miami, FL
    Everywhere Everywhere
    Blog: Blog:
     
    Global Global
    Maui Maui
    London, England London, England
    New York, NY New York, NY
    New York, NY New York, NY
     
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    USA (Formerly @usNOAAgov) USA (Formerly @usNOAAgov)
    Bogotá, Colombia Bogota, Colombia
    Medellín - Colombia Medellin - Colombia
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Colombia Colombia
    Mexico Mexico
    Colombia Colombia
    MIAMI, FL MIAMI, FL
    Colombia Colombia
    Popayán, Cauca, Colombia. Popayan, Cauca, Colombia.
    London London
    ÜT: 4.667453,-74.053682 UT: 4.667453,-74.053682
    United States of America United States of America
    Washington, DC Washington, DC
    Medellín Medellin
    Bogotá Bogota
    New York, NY New York, NY
    Des Moines, IA Des Moines, IA
     
    New York, NY New York, NY
     
    Washington, DC & Portland, OR Washington, DC & Portland, OR
    Washington, DC Washington, DC
    New York New York
    Chicago Chicago
    Bogotá, Colombia Bogota, Colombia
     
    Tallahassee, FL Tallahassee, FL
    B/quilla || San Juan (Guajira) B/quilla || San Juan (Guajira)
    Santa Marta DTCH y Bogotá DC Santa Marta DTCH y Bogota DC
    Vzla, Col, Méx  Vzla, Col, Mex 
    Bucaramanga, Colombia Bucaramanga, Colombia
    Bogotá, Colombia Bogota, Colombia
     
    Santa Marta  Santa Marta 
    bogota bogota
    Bucaramanga Bucaramanga
    Bogota - Berlin Bogota - Berlin
     
    Bogotá Bogota
    Miami Miami
    Colombia Colombia
    »florencia caqueta« >>florencia caqueta<<
    Colombia Colombia
    Bogotá / Cartagena - Colombia Bogota / Cartagena - Colombia
    Bogotá, Col.  Bogota, Col. 
    México Mexico
    México Mexico
    colombia colombia
     
    bogota colombia bogota colombia
    Colombia Colombia
    Miami, FL Miami, FL
    valle del cauca-colombia valle del cauca-colombia
    Zürich, Switzerland Zurich, Switzerland
    COLOMBIA COLOMBIA
    Colombia Colombia
     
    San Francisco San Francisco
    New York, USA New York, USA
    Bogotá-Colombia Bogota-Colombia
     
     
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Neiva Huila Colombia. Neiva Huila Colombia.
    El Salvador, Centroamérica.  El Salvador, Centroamerica. 
     
    Medellín Medellin
    Colombia Colombia
    En toda Colombia En toda Colombia
    La Red del Conocimiento La Red del Conocimiento
    Bogotá D.C. Bogota D.C.
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Colombia Colombia
    Medellín, Colombia Medellin, Colombia
    Cali, Colombia Cali, Colombia
    Bogotá Bogota
    Amsterdam - The Netherlands Amsterdam - The Netherlands
     
    Worldwide (HQ in Atlanta) Worldwide (HQ in Atlanta)
     
    Mexico Mexico
     
    New York City New York City
     
     
    Sweden Sweden
    Argentina Argentina
     
    Perth, Australia Perth, Australia
    Arvada, CO Arvada, CO
    Yemen Yemen
    Stockholm Stockholm
     
    New York, NY New York, NY
    Oslo, Norway Oslo, Norway
    New York New York
    Lindau, Germany Lindau, Germany
    Stockholm, Sweden Stockholm, Sweden
    México Mexico
     
     
    Madison, WI Madison, WI
    Worldwide Worldwide
    New York, NY New York, NY
     
    Washington, D.C. Washington, D.C.
     
    London London
     
     
    London London
    London, UK London, UK
    London London
    New York City New York City
    London, UK London, UK
    London London
    New York and the World New York and the World
    London, UK London, UK
    New York, NY New York, NY
    Los Angeles, CA Los Angeles, CA
    Madrid, España Madrid, Espana
    Valledupar, Cesar, Colombia Valledupar, Cesar, Colombia
    New York City / Worldwide New York City / Worldwide
    New York New York
    New York, NY New York, NY
    Mexico  Mexico 
    Colombia Colombia
    Colombia Colombia
     
     
    USA TODAY HQ, McLean, Va. USA TODAY HQ, McLean, Va.
    Washington, DC Washington, DC
    Around the world. Around the world.
    Colombia Rural Colombia Rural
    Bogotá, Colombia Bogota, Colombia
    Global Global
     
    Miami, Florida Miami, Florida
    Estados Unidos Estados Unidos
    Colombia Colombia
    New York City and the world  New York City and the world 
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá Bogota
    Bogotá Bogota
    Colombia - Bogotá Colombia - Bogota
    Santiago, CHILE Santiago, CHILE
    Everywhere Everywhere
     
    En todas partes En todas partes
    Atlanta, GA. USA Atlanta, GA. USA
    Bogota-Miami Bogota-Miami
    Mexico Mexico
    Perú. Peru.
    Bogotá, Colombia. Bogota, Colombia.
    Bogotá Bogota
    LA - CDMX - AZ LA - CDMX - AZ
     
    Barranquilla - Colombia Barranquilla - Colombia
    México Mexico
    Premio Simon Bolivar 2009 Premio Simon Bolivar 2009
    Bogotá Bogota
    Bogota Bogota
    601 Brickell Key Dr, Suite 103 601 Brickell Key Dr, Suite 103
    Bogotá D.C. Bogota D.C.
     
     
    Brussels, Belgium Brussels, Belgium
    Peru Peru
    Colombia Colombia
    Bogota Bogota
    América/America   America/America  
     
     
    Touring the World Touring the World
    Boston, MA Boston, MA
     
    Swiss Global Citizen Swiss Global Citizen
    London, England London, England
    SF SF
    España Espana
     
    Palm Beach, FL, USA Palm Beach, FL, USA
     ❤️ London...ish ❤️  [?] London...ish [?]
    Las Vegas | NYC | Seattle Las Vegas | NYC | Seattle
    a bit all over the place a bit all over the place
    New Bern, NC New Bern, NC
    Texas Texas
    San Jose, CA San Jose, CA
    Virginia, U.S.A. Virginia, U.S.A.
     
    West London West London
    Airstrip One Airstrip One
    Bogotá, Colombia Bogota, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Mexico Mexico
    Mexico City Mexico City
    Colombia Colombia
    COLOMBIA-MEXICO COLOMBIA-MEXICO
    Bogota Colombia Bogota Colombia
    Planeta Tierra Planeta Tierra
    New York  New York 
     
    Bogotá - Colombia Bogota - Colombia
     
    Mundo Novo, Brasil Mundo Novo, Brasil
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
     
     
    Mexico Mexico
    Colombia  Colombia 
    Bogotá, Colombia Bogota, Colombia
    COLOMBIA COLOMBIA
    Colombia Colombia
     
    ÜT: 4.642363,-74.060456 UT: 4.642363,-74.060456
    Colombia Colombia
     
    the world is my home the world is my home
    Bogotá, Colombia Bogota, Colombia
    Bogota, Colombia Bogota, Colombia
     
    around the world around the world
     
    Palm Beach Gardens, Fl Palm Beach Gardens, Fl
    Somewhere over the Rainbow Somewhere over the Rainbow
    Switzerland Switzerland
    Manacor Manacor
     
     
    Sochi Sochi
     
     
    Barcelona Barcelona
    Bogota Bogota
     Cine Teatro Televisión  Cine Teatro Television
    Everywhere Everywhere
     
    Madrid, Spain Madrid, Spain
     
     
    Bogotá, D.C. Bogota, D.C.
    Bogota Bogota
     
    Santiago de Cali Santiago de Cali
     
    Colombia Colombia
    Colombia Colombia
    Aquí... Hoy Aqui... Hoy
     
    Desubicada a veces Desubicada a veces
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Miami Miami
    Eindhoven Eindhoven
    Medellin Medellin
    Medellín, Antioquia Medellin, Antioquia
    Bogotá D.C, Colombia Bogota D.C, Colombia
    Bogotá, D.C. Bogota, D.C.
    Cali, Colombia Cali, Colombia
    Medellin/Colombia Medellin/Colombia
     
    Medellin-Colombia Medellin-Colombia
    Colombia Colombia
    the world the world
     
    Colombia Colombia
    Colombia Colombia
    Bogotá Bogota
    Colombia Colombia
    Ciudad de México - Medellín Ciudad de Mexico - Medellin
     
    MIAMI MIAMI
    Bogotá Bogota
    Bogotá, Colombia Bogota, Colombia
    ÜT: 6.279094,-75.600952 UT: 6.279094,-75.600952
     
    ÜT: 4.643729,-74.055476 UT: 4.643729,-74.055476
    Bogotá Bogota
    Mil Ciudades Mil Ciudades
    Medellin, Colombia Medellin, Colombia
    Sincelejo - Colombia Sincelejo - Colombia
     
     
    toda Colombia toda Colombia
    Chocó, Colombia Choco, Colombia
     
    Bogota Bogota
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
     
    VALLEDUPAR COLOMBIA VALLEDUPAR COLOMBIA
    Bogotá, Colombia Bogota, Colombia
    Bogotá Bogota
    Colombia Colombia
    Bogotá Bogota
    Bogotá Bogota
     
    Colombia Colombia
    COLOMBIA COLOMBIA
    Miami Miami
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    San Andres islas - Colombia San Andres islas - Colombia
    Colombia Colombia
    Colombia Colombia
    colombia colombia
    Miami - Florida USA Miami - Florida USA
    Bogotá Bogota
    Medellin, CO Medellin, CO
    Colombia Colombia
    Colombia Colombia
    Bogota Bogota
    Bogotá DC. Colombia Bogota DC. Colombia
    Bogota Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogota-Colombia Bogota-Colombia
    ÜT: 4.653332,-74.062218 UT: 4.653332,-74.062218
    Bogota, Colombia Bogota, Colombia
    Bogotá, Colombia Bogota, Colombia
    Instagram: LindaPalma Instagram: LindaPalma
    Bogotá Bogota
    Escritor, mamerto y Senador de la República. Escritor, mamerto y Senador de la Republica.
    Mexico/Colombia/ElMundo Mexico/Colombia/ElMundo
    bogota bogota
    Argentina Argentina
    colombia colombia
    Medellín, Colombia Medellin, Colombia
    Los Ángeles CA Los Angeles CA
    Bogotá Bogota
    Actriz / Colombia   Actriz / Colombia  
    New York, NY New York, NY
    In The Moment In The Moment
    Los Angeles Los Angeles
     
    Los Angeles, California Los Angeles, California
    Colombia-EUA Colombia-EUA
    Colombia Colombia
    Cali Cali
    BOGOTA, COLOMBIA BOGOTA, COLOMBIA
    ÜT: 11.19048,-74.227806 UT: 11.19048,-74.227806
    Instagram @gabodelascasas Instagram @gabodelascasas
    Colombia Colombia
    Bogotá-Colombia Bogota-Colombia
    Bogota- Colombia Bogota- Colombia
    Los Angeles, CA Los Angeles, CA
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Miami, FL Miami, FL
    Colombia Colombia
     
    Colombia  Colombia 
    Bogotá-Colombia. Bogota-Colombia.
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
     
    Colombia Colombia
    planeta azul  planeta azul 
    Colombia Colombia
    Bogotá Bogota
    Colombia Colombia
    instagram.com/marcelaalarcon1 instagram.com/marcelaalarcon1
    Bogotá Bogota
    . .
    Miami, FL Miami, FL
    Bogotá Bogota
    Bogotá, Colombia Bogota, Colombia
    Distrito Federal, México Distrito Federal, Mexico
    Cancún, México.  Cancun, Mexico. 
     
    Dallas, TX Dallas, TX
    Washington, D.C. Washington, D.C.
    Brasília - Brasil Brasilia - Brasil
    ÜT: -22.93364,-43.186087 UT: -22.93364,-43.186087
     
    CDMX CDMX
    Belgium Belgium
    Paris, France Paris, France
    New Zealand New Zealand
    대한민국 daehanmingug
    San José, Costa Rica San Jose, Costa Rica
    Amman, Jordan Amman, Jordan
    Global Global
    Tehran, Iran Tehran, Iran
    France France
    Nederland Nederland
    Vilnius, Lithuania Vilnius, Lithuania
     
    Kremlin, Moscow Kremlin, Moscow
     
    Brussels/Strasbourg Brussels/Strasbourg
    Lebanon | لبنـان Lebanon | lbnn
    Athens, Greece  Athens, Greece 
    Europe Europe
    Malta Malta
    Luxembourg Luxembourg
    London, UK London, UK
    Lebanon | لبنـان Lebanon | lbnn
    Europe Europe
    Strasbourg Strasbourg
    Bamako Bamako
    Jerusalem, Israel Jerusalem, Israel
    Copenhagen | Global Copenhagen | Global
    EU EU
    New York New York
     
    Alaska Alaska
    Geneva, Switzerland Geneva, Switzerland
    Proud Bostonian Proud Bostonian
    New York, NY New York, NY
    Nashville, TN Nashville, TN
    Colombia Colombia
    Bogotá Bogota
    Colombia Colombia
     
    Bogota Bogota
    ¡TODO POR NUESTROS NIÑ@S! !TODO POR NUESTROS NIN@S!
    Bogotá Bogota
    Colombia Colombia
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá - Colombia Bogota - Colombia
    Bogotá D.C. Bogota D.C.
     
    Colombia Colombia
    Manhattan, NY Manhattan, NY
    Chocó  Choco 
    Bruselas / Belgica Bruselas / Belgica
     
    Bogotá, DC, Colombia Bogota, DC, Colombia
     
    Colombia Colombia
    Stanford, CA Stanford, CA
    Paris, France Paris, France
    Honduras Honduras
    Laboule.Rte De Kenscoff Laboule.Rte De Kenscoff
    Ottawa, ON Ottawa, ON
     
    Santo Domingo, Rep. Dominicana Santo Domingo, Rep. Dominicana
    Nicaragua Nicaragua
    Cuba Cuba
    Brasil Brasil
     
    Nairobi, Kenya Nairobi, Kenya
     
     
    Panamá Panama
     
    Calgary, Alberta Calgary, Alberta
    Chile Chile
    United Kingdom United Kingdom
    France  France 
    India  India 
    México Mexico
     
    Moscow Moscow
     
    Venezuela Venezuela
    Ankara Ankara
    Metro Manila, Philippines Metro Manila, Philippines
    Malaysia Malaysia
    Brasília Brasilia
    Dubai, UAE Dubai, UAE
    México Mexico
    Argentina Argentina
    10 Downing Street, London 10 Downing Street, London
    Moscow, Russia Moscow, Russia
     
    Amman, Jordan Amman, Jordan
    İstanbul Istanbul
    Ankara, Turkey Ankara, Turkey
    Washington, D.C. Washington, D.C.
    Washington, DC Washington, DC
    Washington, DC Washington, DC
    Colombia Colombia
     
    Bogotá Bogota
    Colombia Colombia
     
    Colombia-SouthAmerica Colombia-SouthAmerica
    Bogotá Bogota
     
    Risaralda, Colombia Risaralda, Colombia
     
     
    Colombia Colombia
    Cartagena, Colombia Cartagena, Colombia
     
    Bogotá Bogota
    Bogota Bogota
    Colombia Colombia
    Santiago de Cali Santiago de Cali
    Cali, Colombia. Cali, Colombia.
    Colombia Colombia
    COLOMBIA COLOMBIA
    Colombia Colombia
     
    Bogotá DC Bogota DC
    Compra tus entradas ya👇🏼 Compra tus entradas ya
    Bogotá Bogota
    Bogotá Bogota
    Bogotá, Colombia Bogota, Colombia
    Medellín, Colombia Medellin, Colombia
    Medellín, Antioquia Medellin, Antioquia
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Colombia Colombia
    Buenos Aires, Argentina Buenos Aires, Argentina
    Medellín, Colombia Medellin, Colombia
    Bogotá - Colombia Bogota - Colombia
    Barranquilla, Colombia Barranquilla, Colombia
    Medellín, Colombia Medellin, Colombia
    Ciudad de México Ciudad de Mexico
    Colombia Colombia
    Bogotá Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá, Colombia Bogota, Colombia
    Colombia, Suramérica Colombia, Suramerica
    Colombia Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogota - Colombia Bogota - Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogota Bogota
    Bogotá, Colombia Bogota, Colombia
    Bogotá Bogota
    Colombia Colombia
    Medellín - Colombia. Medellin - Colombia.
    Medellin - Colombia Medellin - Colombia
    Bogotá D.C Calle 24 # 5-60 /80 Bogota D.C Calle 24 # 5-60 /80
    Colombia Colombia
    Naciones Unidas Naciones Unidas
    Colombia Colombia
    Nueva York Nueva York
    En el mundo En el mundo
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Bogotá, D.C. - Colombia Bogota, D.C. - Colombia
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá Bogota
    Bogota, Colombia. Bogota, Colombia.
    Colombia Colombia
    Bogotá-Colombia Bogota-Colombia
    Bogotá Bogota
     
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá, D.C. Bogota, D.C.
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, D.C. Bogota, D.C.
    Bogotá, Colombia Bogota, Colombia
    Colombia- Teléfono (1) 5187000 cgr@contraloria.gov.co Colombia- Telefono (1) 5187000 cgr@contraloria.gov.co
    República de Colombia Republica de Colombia
    Colombia Colombia
    Colombia Colombia
    Bogota, Colombia Bogota, Colombia
    Colombia Colombia
     
    Bogotá - Colombia Bogota - Colombia
    Colombia Colombia
    República de Colombia Republica de Colombia
     
    Bogotá, Colombia Bogota, Colombia
    Milano Milano
    colombia  colombia 
     
    Bogotá, Colombia Bogota, Colombia
    Bogotá Bogota
    NYC NYC
     
     
    La Unión, Antioquia. La Union, Antioquia.
     
    Medellín Medellin
    Cúcuta, Colombia Cucuta, Colombia
     
    DE COLOMBIA CON ORGULLO DE COLOMBIA CON ORGULLO
    Bogotá, Colombia Bogota, Colombia
    Ciudad del Vaticano Ciudad del Vaticano
    Ecuador Ecuador
    Colombia Colombia
     
     
    Boyacá, Colombia Boyaca, Colombia
    Worldwide. Worldwide.
    Bogotá, Colombia Bogota, Colombia
    Bogotá - Lima Bogota - Lima
    Guatemala Guatemala
    Colombia Colombia
    Miami, Florida  Miami, Florida 
     
    Colombia Colombia
    Bucaramanga Bucaramanga
    Cali, Colombia Cali, Colombia
    Pereira Pereira
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    México Mexico
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    ÜT: 4.707552,-74.050778 UT: 4.707552,-74.050778
    La Plata, Buenos Aires La Plata, Buenos Aires
    Bogotá, Colombia Bogota, Colombia
    COLOMBIA COLOMBIA
    Colombia Colombia
    Costa Rica Costa Rica
    Mónaco Monaco
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Topeka, Kansas Topeka, Kansas
    Kansas City, MO Kansas City, MO
    San José, Costa Rica San Jose, Costa Rica
    México Mexico
    Miami - USA Miami - USA
    Colombia Colombia
    Santiago de Chile Santiago de Chile
    Caracas,Venezuela Caracas,Venezuela
    México Mexico
    Buenos Aires Buenos Aires
    Entre España y América Entre Espana y America
    Colombia Colombia
    Colombia Colombia
    Bogotá Bogota
    Colombia Colombia
    Bogotá Bogota
    Medellín Medellin
    Barranquilla, Colombia Barranquilla, Colombia
    Valledupar, CO Valledupar, CO
    Munich, Baviera Munich, Baviera
    Valledupar, Colombia Valledupar, Colombia
    Key Biscayne , Fla /  Bogotá Key Biscayne , Fla /  Bogota
    En todas partes/Everywhere. En todas partes/Everywhere.
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá COLOMBIA Bogota COLOMBIA
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Barranquilla, Colombia Barranquilla, Colombia
    Cartagena, Colombia Cartagena, Colombia
    Santiago de Cali Santiago de Cali
    Medellín, Colombia Medellin, Colombia
    Bogotá Distrito Capital Bogota Distrito Capital
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
     
    Cali Cali
    Colombia Colombia
    Bucaramanga - Santander Bucaramanga - Santander
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
     
    Bogota Colombia Bogota Colombia
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogota, Colombia Bogota, Colombia
    Colombia Colombia
    Colombia Colombia
     
    Washington DC  Washington DC 
     
     
    Colombia Colombia
    Colombia Colombia
    Miami, FL Miami, FL
    Barranquilla Barranquilla
    Cuentas claras, cuentas sanas. Cuentas claras, cuentas sanas.
    Colombia Colombia
    Medellín Medellin
    monitoreo@presidencia.Colombia monitoreo@presidencia.Colombia
    Bogota D.C. Bogota D.C.
    Medellín, Colombia Medellin, Colombia
    Bogotá, Colombia Bogota, Colombia
    Urrao, Colombia Urrao, Colombia
    Colombia Colombia
    Costa Rica. México. Washington Costa Rica. Mexico. Washington
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
     
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá Bogota
    Bogotá, D.C. - Colombia Bogota, D.C. - Colombia
    Colombia Colombia
     
    Colombia Colombia
     
    Bogotá, Colombia. Bogota, Colombia.
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Lima Perú Lima Peru
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    , costas y ríos de CO. , costas y rios de CO.
    México Mexico
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    BARRANQUILLA BARRANQUILLA
    Colombia Colombia
     
    Soacha, Colombia Soacha, Colombia
     
     
     
     
    Venezuela Venezuela
    COLOMBIA  COLOMBIA 
    Venezuela Venezuela
    Valencia VENEZUELA!!!!!!!! Valencia VENEZUELA!!!!!!!!
    Bogotá Bogota
     
    Bogotá - Colombia Bogota - Colombia
    Bogotá.D.C. Colombia Bogota.D.C. Colombia
     
    Colombia Colombia
    Medellín, Antioquia Medellin, Antioquia
    Bogotá, Colombia Bogota, Colombia
    Bogota, Colombia Bogota, Colombia
    Colombia Colombia
    ÜT: 4.684675,-74.046089 UT: 4.684675,-74.046089
    Bogotá- Colombia Bogota- Colombia
    ÜT: 34.022451,-84.259735 UT: 34.022451,-84.259735
    Atlanta, GA Atlanta, GA
    Macondo Macondo
    Medellín Medellin
    Here, There and Everywhere Here, There and Everywhere
    Colombia Colombia
    Antioquia, Colombia Antioquia, Colombia
    Bogotá,Colombia Bogota,Colombia
    Bogotá ( Colombia ) Bogota ( Colombia )
    Bogotá, Colombia Bogota, Colombia
    colombia colombia
    Barranquilla Barranquilla
     
    Bogotá, Miami, CDMX Bogota, Miami, CDMX
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Bogotá Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    It’s Colombia, not Columbia It's Colombia, not Columbia
    Bogotá Bogota
    Colombia Colombia
    Washington, DC Washington, DC
    Washington, DC, EE.UU. Washington, DC, EE.UU.
    Washington, D.C. Washington, D.C.
    Washington, DC Washington, DC
     
    Berlin, Germany Berlin, Germany
    Michigan/New York City Michigan/New York City
    Washington, D.C. Washington, D.C.
    Arlington, Va. Arlington, Va.
    New York, NY New York, NY
    Quito, Ecuador Quito, Ecuador
     
    México Mexico
    Washington, DC Washington, DC
    Bogotá, Colombia Bogota, Colombia
    Bogotá Bogota
    Colombia Colombia
    Bogotá - Colombia Bogota - Colombia
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Estados Unidos Estados Unidos
    Bogotá Bogota
    Bogotá Bogota
    San Francisco, California San Francisco, California
    Bogotá, Colombia. Bogota, Colombia.
    Colombia Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    BOGOTA BOGOTA
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
     
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Chile Chile
    Colombia Colombia
    Colombia Colombia
    Bogotá D.C., Colombia Bogota D.C., Colombia
    Caracas - Venezuela Caracas - Venezuela
    spain spain
    Bogotá, Colombia Bogota, Colombia
    Bogotá Bogota
    Nariño, Colombia Narino, Colombia
    Caracas, Venezuela Caracas, Venezuela
    Bogotá Bogota
    Colombia Colombia
    Barranquilla Barranquilla
    Colombia Colombia
    Caracas - Venezuela Caracas - Venezuela
    Barranquilla - Bogotá - México Barranquilla - Bogota - Mexico
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
     
    Bogotá Bogota
     
    Colombia Colombia
    New York, NY New York, NY
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Berkeley, CA Berkeley, CA
    Colombia Colombia
    ÜT: 4.667895,-74.044464 UT: 4.667895,-74.044464
    Bogotá, Colombia Bogota, Colombia
    Bogotá, Colombia Bogota, Colombia
    Antioquia, Colombia Antioquia, Colombia
    Miami, FL Miami, FL
    Bogotá Bogota
    Medellín, Colombia Medellin, Colombia
     
    We're Global! We're Global!
    Bogotá, Colombia Bogota, Colombia
    A veces aquí.  A veces aqui. 
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    New York, NY New York, NY
    BOSTON MA USA BOSTON MA USA
    EN LA VIDA EN MOVIMIENTO EN LA VIDA EN MOVIMIENTO
    Rionegro, Antioquia, Colombia. Rionegro, Antioquia, Colombia.
     
    ÜT: 6.209317,-75.600865 UT: 6.209317,-75.600865
    Macondo Macondo
    Medellín Medellin
    Manizales, Colombia Manizales, Colombia
     
    Bogota D.C. Bogota D.C.
    Antioquia, Colombia Antioquia, Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá, Colombia. Bogota, Colombia.
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Bogotá D.C. / Colombia Bogota D.C. / Colombia
    Santiago de Cali, Colombia.  Santiago de Cali, Colombia. 
    Bogotá D.C. - Vladivostok Bogota D.C. - Vladivostok
     
    Colombia Colombia
    Colombia Colombia
    Bogotá Bogota
     
    Colombia Colombia
     
    Bogotá, Colombia Bogota, Colombia
    Medellín, Antioquia Medellin, Antioquia
     
    Barranquilla, Colombia Barranquilla, Colombia
     
    Medellín, Antioquia Medellin, Antioquia
     
     
    Bogotá Bogota
    Colombia Colombia
    Antioquia, Colombia Antioquia, Colombia
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
     
    Medellin - Colombia  Medellin - Colombia 
    Colombia Colombia
    Bogotá Bogota
    Cali, Colombia Cali, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Medellín Medellin
    Bogotá Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Bogotá Bogota
    Colombia Colombia
    Armenia,Quindío Armenia,Quindio
    Colombia Colombia
    Tulua, Valle del Cauca Tulua, Valle del Cauca
     
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Toronto Toronto
    Bogotá, Colombia Bogota, Colombia
    Barranquilla, Colombia Barranquilla, Colombia
    Bogotá  Bogota 
     
    ÜT: 4.59517,-74.077369u UT: 4.59517,-74.077369u
    Bogotá Bogota
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
     
     
    Paris (F)-Medellín(COL) Paris (F)-Medellin(COL)
    @ 102 @ 102
    Valle del Cauca, Colombia Valle del Cauca, Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Barranquilla Barranquilla
    @Bogotá D.C @Bogota D.C
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Bogota D.C. Bogota D.C.
    Bogota City Bogota City
    Bogotá Bogota
    Sincelejo -  SUCRE Sincelejo -  SUCRE
     
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Ibague Colombia Ibague Colombia
    de Barrancabermeja, Santander de Barrancabermeja, Santander
    Barranquilla, Colombia Barranquilla, Colombia
     
    Bogotá, Colombia Bogota, Colombia
    Bogotá Bogota
    Cali, Colombia Cali, Colombia
    Hipocresíalandia (mzl) co Hipocresialandia (mzl) co
    Colombia Colombia
    Villavicencio Meta Colombia Villavicencio Meta Colombia
     
    Santa Marta, Colombia Santa Marta, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    BOGOTA COLOMBIA BOGOTA COLOMBIA
    Bogotá, Colombia Bogota, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá - Colombia Bogota - Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogota Bogota
    Medellín, Colombia Medellin, Colombia
    England England
     
     
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Bogotá Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Valledupar, Colombia Valledupar, Colombia
    Cali, Colombia Cali, Colombia
    Villanueva, La Guajira Villanueva, La Guajira
    Toribio, Colombia Toribio, Colombia
    Bogotá, Colombia Bogota, Colombia
    Colombia, Bogota Colombia, Bogota
    Barranquilla Barranquilla
    Space Oddity Space Oddity
    I'm always home, I'm uncool. I'm always home, I'm uncool.
    Medellin Medellin
     
    Cali, Colombia Cali, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    cali, colombia cali, colombia
     
    Eje Cafetero Eje Cafetero
     
     
    Manizales, Colombia Manizales, Colombia
    Bogotá, DC, Colombia Bogota, DC, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Bucaramanga, Colombia Bucaramanga, Colombia
    #Colombia #Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Cundinamarca, Colombia Cundinamarca, Colombia
     
     
     
     
     
    Montería, Colombia Monteria, Colombia
     
     
     
    Colombia Colombia
     
     
    Colombia Colombia
     
     
     
    Boyacá-Colombia Boyaca-Colombia
     
     
     
     
    Bogotá Colombia Bogota Colombia
    Colombia Colombia
     
    Colombia Colombia
    Bogotá Bogota
     
     
    Cali, Colombia Cali, Colombia
    COLOMBIA COLOMBIA
     
    . .
    Bogota, Colombia Bogota, Colombia
    Bogota Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Medellín, Colombia Medellin, Colombia
    Manizales Manizales
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Medellín, Colombia Medellin, Colombia
    Colombia Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
     
     
     
    Medellín, Colombia Medellin, Colombia
    Manizales, Colombia Manizales, Colombia
    BOGOTA D.C. BOGOTA D.C.
     
     
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
     
    Fusagasugá, Colombia Fusagasuga, Colombia
     
    Cali, Colombia Cali, Colombia
     
    Buga Buga
    Cali, Colombia Cali, Colombia
    colombia colombia
    Colombia Colombia
    Valledupar, Colombia Valledupar, Colombia
     
     
    Pereira. Pereira.
     
     
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Apartadó, Antioquia Apartado, Antioquia
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Habitante del planeta Tierra Habitante del planeta Tierra
     
    corregimiento de guacoche corregimiento de guacoche
    Villavicencio, Meta Villavicencio, Meta
    Bogotá Bogota
    Barcelona, Spain Barcelona, Spain
    Bogotá, Colombia Bogota, Colombia
    ;) ;)
     
     
    Caracas, Venezuela Caracas, Venezuela
    Colombia Colombia
     Cualquier rincón de C/marca.  Cualquier rincon de C/marca.
    Bogotá Bogota
     
    Santiago de Cali Santiago de Cali
    Manizales Manizales
    Bogotá. Bogota.
     
    miami miami
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    COLOMBIA COLOMBIA
    Cartagena, Colombia Cartagena, Colombia
    Sabaneta, Colombia Sabaneta, Colombia
    Manizales, Caldas Manizales, Caldas
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    bogota bogota
    Colombia Colombia
    Bucaramanga/Bogotá , Colombia Bucaramanga/Bogota , Colombia
    Colombia Colombia
    Bogota Bogota
     
    BOGOTÁ, COLOMBIA BOGOTA, COLOMBIA
    Bucaramanga, Santander Bucaramanga, Santander
    Santa Marta,Colombia Santa Marta,Colombia
    Barrancas, Colombia Barrancas, Colombia
     
     
    The Woodlands, TX The Woodlands, TX
    Bogota Bogota
    Pereira, Colombia Pereira, Colombia
    Bogota Bogota
    Colombia Colombia
    Bogotá Bogota
    Bogotá Bogota
     
     
    Melbourne, Victoria Australia  Melbourne, Victoria Australia 
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, Colombia Bogota, Colombia
    Cartagena, Colombia Cartagena, Colombia
    Colombia Colombia
     
    Colombia Colombia
     
    Dystopia Dystopia
     #CabezaFría  #CabezaFria
    Madrid - Bogotá Madrid - Bogota
    mar  mar 
    Cali, Colombia Cali, Colombia
    Bogota,  Barrios Unidos Bogota,  Barrios Unidos
    Cartagena, Colombia Cartagena, Colombia
    Cartagena de Indias - Bolívar Cartagena de Indias - Bolivar
    Colombia Colombia
    Colombia Colombia
    Medellín Medellin
    Bogotá, Colombia Bogota, Colombia
    Latinoamérica Latinoamerica
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Antioquia, Colombia Antioquia, Colombia
    De aquí y de allá De aqui y de alla
    Bogotá, Colombia Bogota, Colombia
    Bogotá, Colombia Bogota, Colombia
    colombia colombia
     
    Medellín - Colombia Medellin - Colombia
    Medellin, Antioquia Medellin, Antioquia
    Colombia Colombia
    Sn Bdo Vto -Córdoba- Colombia. Sn Bdo Vto -Cordoba- Colombia.
    Donde sea. Donde sea.
    Cúcuta. Cucuta.
    Colombia Colombia
    de ideas liberale mde de ideas liberale mde
    Medellin Medellin
    Bogotá, Colombia Bogota, Colombia
    Cape Coral Fl Cape Coral Fl
     
    Brooklyn, NY Brooklyn, NY
    Medellín Medellin
    Manizales, Colombia Manizales, Colombia
    ciudadano del mundo ciudadano del mundo
    Colombia Colombia
    Medellin, eterna Primavera  Medellin, eterna Primavera 
     
    Bogotá Bogota
    Bogotá, Colombia Bogota, Colombia
     
    Bogotá, Colombia Bogota, Colombia
     
     COLOMBIA  COLOMBIA
    Manizales, Colombia Manizales, Colombia
    Medellín Medellin
     
    Plutón *The Planet* Pluton *The Planet*
    Bogotá. Colombia Bogota. Colombia
    Bogota/Colombia Bogota/Colombia
     
     
    Medellín, Colombia Medellin, Colombia
    Colombia Colombia
     
    Bogotá, DC, Colombia Bogota, DC, Colombia
    La Estrella - Antioquia La Estrella - Antioquia
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bucaramanga, Colombia Bucaramanga, Colombia
    Pereira la llevo puesta Pereira la llevo puesta
    Colombia. Colombia.
    Medellín, Colombia. Medellin, Colombia.
    Colombia Colombia
    Medellín, Colombia Medellin, Colombia
     
    Colombia, tierra querida Colombia, tierra querida
    BOGOTA-COLOMBIA BOGOTA-COLOMBIA
    Del Tajo a la Sierra de Gredos Del Tajo a la Sierra de Gredos
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Colombia/España Colombia/Espana
    Medellín. Medellin.
    Manizales, Colombia Manizales, Colombia
    BARRANQUILLA BARRANQUILLA
    Colombia Colombia
    Miami Miami
    Bogotá-Colombia Bogota-Colombia
    Bogotá D.C. Colombia Bogota D.C. Colombia
    Cartagena Cartagena
     
    Bello Bello
    COLOMBIA COLOMBIA
    Cayman Islands Cayman Islands
    En un alveolo En un alveolo
    Bogotá D.C.  Bogota D.C. 
     
    Medellín, Cali, Rep Dominicana Medellin, Cali, Rep Dominicana
    Medellín, Colombia Medellin, Colombia
    Colombia Colombia
    Bogota Bogota
    Envigado, Colombia Envigado, Colombia
     
    Bogotá D.C.- Colombia Bogota D.C.- Colombia
    Colombia Colombia
    Bucaramanga Bucaramanga
    Manizaleño en Bogotá Manizaleno en Bogota
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Medellín-Colombia Medellin-Colombia
    Chía, Colombia Chia, Colombia
     
    Bogota, Colombia Bogota, Colombia
    Colombia Colombia
    Colombia Colombia
     
    Bogotá D.C Bogota D.C
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá Bogota
    Colombia Colombia
    j.alban@uniandes.edu.co j.alban@uniandes.edu.co
    Sabana de Bogotá, COLOMBIA Sabana de Bogota, COLOMBIA
    Periodista, editora. Colombia  Periodista, editora. Colombia 
     
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Boyacá, Colombia Boyaca, Colombia
    ibague ibague
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotà, Colombia Bogota, Colombia
    Bogotá D.C. Bogota D.C.
     
    Bogotá - Colombia Bogota - Colombia
    Medellín, Colombia Medellin, Colombia
     
    Sincelejo Sincelejo
    Bogotá, DC, Colombia Bogota, DC, Colombia
     QUIMICAMENTE PERIODISTA .  QUIMICAMENTE PERIODISTA .
    Bogota Bogota
    Bogotá Bogota
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    ÜT: 4.654361,-74.044616 UT: 4.654361,-74.044616
    Colombia Colombia
    Colombia Colombia
    de Cúcuta - en Bogotá Colombia de Cucuta - en Bogota Colombia
    Colombia Colombia
     
    Colombia Colombia
    Cartagena de Indias, Colombia Cartagena de Indias, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Barranquilla Barranquilla
     
    Colombia Colombia
     
    Bogotá D.C. Bogota D.C.
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Donmatías, Colombia Donmatias, Colombia
    Bogotá Colombia Bogota Colombia
    Medellín, Colombia Medellin, Colombia
    Medellín, Colombia Medellin, Colombia
    Colombia Colombia
     
    Bogotá Bogota
    Bogotá Bogota
     
     
     
    Medellin Medellin
     
    Medellin, Colombia Medellin, Colombia
    Bogotá D.C. / Colombia Bogota D.C. / Colombia
    Medellín, Colombia Medellin, Colombia
     
     
    Colombia Colombia
    Tunja, Colombia Tunja, Colombia
    Medellín, Colombia Medellin, Colombia
    Ibague Ibague
    Bogotá, Colombia Bogota, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Norte de Santander, Colombia Norte de Santander, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
     
     
    Bogotá, Colombia Bogota, Colombia
    BOG / BGA / VVC / VUP BOG / BGA / VVC / VUP
    Knoxville, TN Knoxville, TN
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Medellín, Colombia Medellin, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Bogota  Bogota 
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Delhi via London & Yorkshire Delhi via London & Yorkshire
    Medellín, Colombia Medellin, Colombia
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Medellín, Colombia Medellin, Colombia
    VILLAVICENCIO   COLOMBIA VILLAVICENCIO   COLOMBIA
    Antioquia, Colombia Antioquia, Colombia
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá- Colombia Bogota- Colombia
    Holanda y Alemania Holanda y Alemania
    Medellín, Colombia Medellin, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Spain Spain
    Barranquilla, Colombia Barranquilla, Colombia
    Bogotá  Bogota 
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Manizales Caldas Colombia  Manizales Caldas Colombia 
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Cúcuta. Colombia Cucuta. Colombia
    Cali...Hermosa a pesar de todo Cali...Hermosa a pesar de todo
    Bogota Bogota
    Medellín, Colombia Medellin, Colombia
    Cartagena, Colombia Cartagena, Colombia
    Bogota - Colombia Bogota - Colombia
    Bogotá, Colombia Bogota, Colombia
    Medellín - Rodania [Costeño]* Medellin - Rodania [Costeno]*
    Bogota Bogota
    Cartagena-Colombia. Cartagena-Colombia.
    Medellín, Colombia. Medellin, Colombia.
    Colombia Colombia
    Medellín, Colombia Medellin, Colombia
    colombia colombia
     
    Soacha, Colombia Soacha, Colombia
     
    CALI CALI
    Bogotá Bogota
    Cartagena  - Colombia Cartagena  - Colombia
    Bogotá, CO. Bogota, CO.
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Pereira, Colombia Pereira, Colombia
    Manizales Manizales
    Santa Marta Santa Marta
    Bogotá Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Medellín Medellin
    Miami, FL Miami, FL
    Verde🌻 111 Cámara Bogotá Verde 111 Camara Bogota
    Bogotá D.C. Bogota D.C.
    Boston Boston
    Bogotá, Colombia Bogota, Colombia
    Bogotá Bogota
     
     
    Bogotá, Colombia Bogota, Colombia
     
    Miami, FL Miami, FL
    Bogotá, Miami, CDMX Bogota, Miami, CDMX
    Pasto|Linares (N)|Bogotá Pasto|Linares (N)|Bogota
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Manizales, Colombia Manizales, Colombia
     
    Bogotá, DC, Colombia Bogota, DC, Colombia
    informacion@cangrejoperez.com informacion@cangrejoperez.com
     
    Oslo, Norway Oslo, Norway
    Medellín Medellin
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    . .
    Bogotá-Colombia Bogota-Colombia
    New York City New York City
     
    Argentina Argentina
    Bogotá Bogota
     
    colombia colombia
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    New York, USA New York, USA
     
    Pasto-Bogotá Pasto-Bogota
    Medellin, Colombia Medellin, Colombia
    Bogotá, Colombia Bogota, Colombia
    Distrito Federal, México Distrito Federal, Mexico
    Antioquia Antioquia
    Barranquilla, Colombia Barranquilla, Colombia
    Bogotá, Colombia Bogota, Colombia
     
    Manizales Manizales
     
    Princeton, NJ Princeton, NJ
    Medellín, Colombia Medellin, Colombia
    Colombia Colombia
    Colombia Colombia
    Planeta Tierra Planeta Tierra
     
    Bogotâ Bogota
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Bogotá Bogota
    Bogotá D.C., Colombia Bogota D.C., Colombia
     
    Bogotá, Colombia Bogota, Colombia
     
    Bogota Bogota
    Colombia  Colombia 
    Bogota,Colombia Bogota,Colombia
     
    Cali, Colombia Cali, Colombia
    Paris, France Paris, France
    Medellín - Bogotá Medellin - Bogota
    Zipaquirá - Bogotá.  Zipaquira - Bogota. 
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    San Juan de Pasto. San Juan de Pasto.
    Colombia Colombia
    Bogota, Colombia Bogota, Colombia
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Colombia Colombia
    Bogotá Bogota
    Colombia Colombia
    República de Colombia Republica de Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá Bogota
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá - Colombia Bogota - Colombia
    Colombia Colombia
    Colombia Colombia
    Bogotá Bogota
    New York City New York City
    , costas y ríos de CO. , costas y rios de CO.
    Calle 36 # 28A-24 Bogota Calle 36 # 28A-24 Bogota
    Colombia Colombia
     
    Bogotá Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá Bogota
    Bogotá Distrito Capital Bogota Distrito Capital
    Bogotá, Colombia Bogota, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    BOGOTÁ, COLOMBIA BOGOTA, COLOMBIA
    Colombia Colombia
    Popayán, Colombia Popayan, Colombia
    Global Global
    En Colombia...Por fin Colombia! En Colombia...Por fin Colombia!
    Colombia Colombia
    New York, Washington DC, Miami New York, Washington DC, Miami
    Bogotá, Colombia Bogota, Colombia
    Colombia. Colombia.
     
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Colombia Colombia
     
    Bogotá  Bogota 
    Colombia Colombia
    Bogotá Bogota
     
    Bogotá, Colombia Bogota, Colombia
    Bogotá Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá Bogota
    Colombia Colombia
     
    Colombia Colombia
     
    BOGOTA, COLOMBIA BOGOTA, COLOMBIA
     
    Bogotá, Colombia Bogota, Colombia
    London, England London, England
    Buenos Aires, Argentina Buenos Aires, Argentina
    Popayán, Cauca, Colombia. Popayan, Cauca, Colombia.
    Washington D.C. Washington D.C.
    Bogotá, Colombia. Bogota, Colombia.
    Colombia Colombia
    Cuentas claras, cuentas sanas. Cuentas claras, cuentas sanas.
    New York New York
     
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Cable Noticias Cable Noticias
    Bogotá-Buenos Aires Bogota-Buenos Aires
    Bogotá Bogota
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Nacional Nacional
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá Bogota
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
     
    En la olla En la olla
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá D.C. Bogota D.C.
     
    Bogota Colombia Bogota Colombia
    New York, NY New York, NY
    New York, NY New York, NY
    London London
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Cali - Colombia Cali - Colombia
    Munich, Baviera Munich, Baviera
     
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
     
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
     
    República de Colombia Republica de Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Instagram: hassannassar Instagram: hassannassar
    Bogotá-Colombia Bogota-Colombia
     
     
     
    Bogota, Colombia Bogota, Colombia
     
    Colombia Colombia
    Bogota Bogota
    Santiago de Cali Santiago de Cali
    Sintonizanos: Sintonizanos:
    Cali, Colombia Cali, Colombia
    Cali Cali
    Cali, Colombia Cali, Colombia
    Cali, Valle del Cauca. Cali, Valle del Cauca.
    Cali, Colombia Cali, Colombia
    santiago de cali, colombia santiago de cali, colombia
    Colombia Colombia
    Colombia Colombia
     
    Bogotá D.C. Bogota D.C.
    Bogotá, D.C. - Colombia Bogota, D.C. - Colombia
     
    London, UK London, UK
    London London
    Bogotá  Bogota 
    medellin medellin
    Instagram @gabodelascasas Instagram @gabodelascasas
     
    Bogota, Colombia Bogota, Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia - Bogotá Colombia - Bogota
    Colombia Colombia
     
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Medellín, Colombia Medellin, Colombia
    Barcelona, Spain Barcelona, Spain
     
    Colombia Colombia
    Bogotá Bogota
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    México-Colombia-Venezuela Mexico-Colombia-Venezuela
    Colombia Colombia
     
    Cartagena de Indias - Colombia Cartagena de Indias - Colombia
    Armenia, Colombia Armenia, Colombia
    España Espana
    Madrid, Comunidad de Madrid Madrid, Comunidad de Madrid
    Madrid Madrid
    Londres, Inglaterra. Londres, Inglaterra.
    En todas partes En todas partes
    Atlanta, GA Atlanta, GA
     
     
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá, D.C. Bogota, D.C.
    Barranquilla, Colombia Barranquilla, Colombia
    Colombia - Bogotá D.C. Colombia - Bogota D.C.
    Sweden Sweden
     
    colombia colombia
     
    Bogotá, Colombia Bogota, Colombia
    Bogotá, Colombia Bogota, Colombia
    ÜT: 6.210789,-75.564233 UT: 6.210789,-75.564233
     
    Airplane Airplane
    Bogotá, Colombia Bogota, Colombia
     
    Bogotá Bogota
    Bogota, Colombia Bogota, Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotà Bogota
    Colombia Colombia
    Bogotá D.C Bogota D.C
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogota, Colombia Bogota, Colombia
    Bogotá, D.C  Bogota, D.C 
    Colombia Colombia
     
    Bogotá, Colombia Bogota, Colombia
    ÜT: 4.650541,-74.074043 UT: 4.650541,-74.074043
    Bogotá, Colombia Bogota, Colombia
     
    Barranquilla - Bogotá - México Barranquilla - Bogota - Mexico
    Bogotá, Colombia Bogota, Colombia
    Bogotá D.C. Bogota D.C.
     
    Colombia Colombia
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Bogotá, D.C. Bogota, D.C.
    Bogotá Bogota
    Colombia- Teléfono (1) 5187000 cgr@contraloria.gov.co Colombia- Telefono (1) 5187000 cgr@contraloria.gov.co
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    En toda Colombia En toda Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Colombia Colombia
    Bogotá Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    Candelaria, Colombia Candelaria, Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá - Colombia Bogota - Colombia
    Bogotá Bogota
     
    Bogotá Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Bogotá Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Bogota-Colombia Bogota-Colombia
     
    Colombia Colombia
    Colombia Colombia
     
    Bogotá, Colombia Bogota, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Bogotá Bogota
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá COLOMBIA Bogota COLOMBIA
    Bogotá, Colombia Bogota, Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Bogotá Bogota
     
     
    Bogotá Bogota
     
    Colombia Colombia
     
    Todos podemos cambiar el mundo Todos podemos cambiar el mundo
    Bogotá, Colombia Bogota, Colombia
    Bogotá Bogota
    Bogota Colombia Bogota Colombia
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Medellín, Colombia Medellin, Colombia
    Venezuela Venezuela
    Medellín Medellin
    Continente Americano Continente Americano
    Medellìn Medellin
    Medellín, Antioquia Medellin, Antioquia
    Antioquia, Colombia Antioquia, Colombia
    Medellín Medellin
    Colombia Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá, Colombia Bogota, Colombia
    Bogotá, Colombia. Bogota, Colombia.
    Bogotá, Colombia Bogota, Colombia
    Colombia Colombia
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
    Colombia Colombia
    Colombia Colombia
    Colombia Colombia
    It’s Colombia, not Columbia It's Colombia, not Columbia
    Colombia Colombia
    Medellín Medellin
    Bogotá Bogota
    Armenia Armenia
     
     
    Colombia Colombia
    Miami, FL Miami, FL
    Vermont/DC Vermont/DC
    Bogotá Bogota
    Bogotá, D.C., Colombia Bogota, D.C., Colombia
     
    Bogotá D.C., Colombia Bogota D.C., Colombia
    New York, NY New York, NY
    Bogotá, DC, Colombia Bogota, DC, Colombia
    Colombia Colombia
    

### ...Time to move to data cleaning and visualization in R
(After waiting 3 hours for the data collecting loop to run and write the csv all the way through! I ran mine overnight.)

# C) Download tweets from time-windows
[Also under construction]


```python
startDate_1 = datetime.datetime(2014, 5, 1, 0, 0, 0) #elections
endDate_1 = datetime.datetime(2014, 8, 1, 0, 0, 0)

startDate_2 = datetime.datetime(2016, 9, 1, 0, 0, 0) #Plebiscite vote on ratification
endDate_2 = datetime.datetime(2016, 12, 31, 0, 0, 0)

startDate_3 = datetime.datetime(2018, 3, 1, 0, 0, 0) #current elections
endDate_3 = datetime.datetime(2018, 7, 1, 0, 0, 0)

```


```python
# for name in elites:
#     tweepy.Cursor(API.user_timeline, elites[name])

```


```python
#test_tweets = API.user_timeline(screen_name='IvanDuque', since_id=981697880766468097, count=20, tweet_mode='extended')
```


```python
# print("Recent tweets:\n")
# for tweet in test_tweets:
#     print(tweet.full_text)
#     print()
```

    Recent tweets:
    
    Está noche estaremos nuevamente en #PreguntaYamid en el canal @elunodetodos @CMILANOTICIA Acompáñanos! #DuqueEsElQueEs https://t.co/PbeCKQasyr
    
    RT @CMILANOTICIA: Hoy desde las 10:00 p. m. no te pierdas en #PreguntaYamid  la segunda parte de la entrevista al candidato presidencial @I…
    
    La economía no se recupera a base de impuestos, se recupera con un gobierno austero, que elimine el derroche y los gastos innecesarios, que piense en el ciudadano y permita mejorar la inversión y generar empleo formal #HotelElPradro #DuqueEsElQueEs https://t.co/0MIUqA6hw7
    
    Aquí está el segundo carnaval más grande de América Latina, donde el folclor y la cultura unen a todo un país. Barranquilla nos demuestra la importancia de apostarle a la economía naranja y a las industria creativas #HotelElPradro #DuqueEsElQueEs https://t.co/t4WLolIs33
    
    Vamos a llegar a la presidencia a defender la legalidad, a luchar contra la impunidad, contra la inseguridad, contra la prostitución infantil. En defensa de esa legalidad vamos a instaurar la cadena perpetua para violadores y asesinos de niños #HotelElPrado #DuqueEsElQueEs https://t.co/VPM0oKMQ5z
    
    Amigos de #Barranquilla, estamos a menos de 60 días de lograr el anhelo por el que venimos trabajado. Estoy seguro que, junto con @mluciaramirez y con el apoyo de ustedes, vamos a ganar la presidencia en la primera vuelta #HotelElPrado #DuqueConElCaribe https://t.co/e6JrAMuKbJ
    
    RT @IvanDuque: Con @mluciaramirez estamos muy agradecidos por el apoyo de una de las glorias del deporte colombiano, el gran beisbolista Ed…
    
    RT @JaimeAminH: Barranquilla acoge con afecto multitudinario y espontáneo a @IvanDuque Pdte y @mluciaramirez VPdte. https://t.co/jf8tSQMDg1
    
    En directo, desde Barranquilla junto a @mluciaramirez en encuentro con amigos y simpatizantes. https://t.co/CvAWXfAb58
    
    Vamos a darle la posibilidad a las empresas nacientes, que generen un mínimo de empleo, y desarrollen inversiones en sectores creativos, tecnológicos y de transformación productiva, que no paguen impuesto de renta en los primeros cinco años #DuqueConLosEstudiantes @UniversidadCUC https://t.co/QJjFBO3jUo
    
    El Icetex necesita una gran reforma. Debemos desarrollar programas de financiamiento sin codeudor, y que no se le empiece a cobrar al estudiante cuando haya terminado sus estudios, sino cuando consiga su primer empleo  #DuqueConLosEstudiantes
    @UniversidadCUC https://t.co/0ZFIQrRrkb
    
    En Barranquilla junto a @mluciaramirez compartimos nuestras principios de Gobierno: legalidad, emprendimiento y equidad, con los estudiantes y egresados de la @UniversidadCUC #DuqueConLosEstudiantes https://t.co/C7nmmS5OJH
    
    Con @mluciaramirez estamos muy agradecidos por el apoyo de una de las glorias del deporte colombiano, el gran beisbolista Edgar Rentería. Nos llena de entusiasmo contar con su respaldo y nos motiva a ‘sacarla del estadio’, el próximo 27 de mayo #DuqueEsElQueEs https://t.co/YVpEsD4WsG
    
    En directo con @Mluciaramirez en Barrranquilla, en La Universidad de La Costa dialogando con estudiantes. https://t.co/JmSul4uyDL
    
    Gracias a todos los organizadores del #DebateCaribe por este espacio para compartir nuestra visión de país. Gracias #Barranquilla @elheraldoco  @Camarabaq @AmChamCol @ANDI_Colombia y @ProBaq #DuqueConElCaribe #DuqueEsElQueEs https://t.co/OhH1hva0pQ
    
    #Barranquilla I Yo quiero ser el presidente de la visión de futuro, donde no nos quedemos en debates anacrónicos de izquierda y derecha, sino que miremos hacía adelante. Ese es el país que quiero que me acompañen a construir con determinación #DebateCaribe #DuqueConElCaribe https://t.co/p02UAXXqwP
    
    #Barranquilla Queremos construir un país de equidad con educación preescolar, jornada única, doble titulación y acceso gratuito a la universidad virtual y presencial para los más vulnerables, y un sistema de salud de calidad donde las EPS no abusen del ciudadano #DuqueConElCaribe https://t.co/jIWTgIpnJx
    
    #Barranquilla I Nuestra Costa Caribe y el país necesitan emprendimiento. Queremos una Colombia donde haya industrias creativas, energías renovables, agroindustria, turismo, ecoturismo, bioturismo, empleo y oportunidades para prosperar #DebateCaribe #DuqueConElCaribe https://t.co/ZSCIhRe9Jv
    
    #Barranquilla I Yo quiero ser el presidente de un país con legalidad, donde todo el que esté al margen de la ley tenga sanción, donde el ciudadano se sienta seguro en las calles y en el que podamos derrotar la corrupción #DebateCaribe #DuqueConElCaribe https://t.co/oMcLLqTyU3
    
    #Barranquilla I Como presidente ayudaré, en el escenario multilateral, a que caiga la dictadura de Maduro, y conformar un Plan Venezuela, con organismos internacionales y otros países, para permitir el regreso de los venezolanos y la recuperación de la economía #DuqueConElCaribe https://t.co/dAYoFnoJES
    
    
