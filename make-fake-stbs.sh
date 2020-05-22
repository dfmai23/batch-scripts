#!/bin/bash


cmd=$0  #$0, 0th pos arg, shell script name


while [ -n "$*" ]; do #-n not null
  case $1 in
  -d) delete=true; shift;   #-d directory, shift to next pos arg
      ;;                    #delete accounts if folder param
  *)  if [ -n "$count" ]; then
        echo "usage: $cmd [-d] number-of-stbs"
        exit
      fi
      count=$1; shift;
      ;;
  esac
done

if [ -z "$count" ]; then  #-z, is null
  echo "usage: $cmd [-d] number-of-stbs"
  exit
fi

host=https://pi.engprod-spectrum.net 		#https://pi-dev.timewarnercable.com base path to the appropriate PI Gateway
username=msuganth				# basic auth username for the MAS
password=msuganth				# basic auth password for the MAS
divcode=ATGW-SIT02				# division code for the MAS
divid=SGTST					# billing division id for created accounts
billid=4444					# billing slice for created accounts
acntfmt=44444444%08d				# billing account id format for created accounts
name=default					# the default user's name for each created account
hubid=4444					# hub id for created STBs
macfmt=44444444%04x				# mac address format for created STBs

sppGet()
{
  url=$1
  curl -sw "\n\n" -k -u ${username}:${password} -X GET ${host}/spp/v1/${url}
}

sppPost()
{
  url=$1
  curl -sw "\n\n" -k -u ${username}:${password} -X POST -H Content-Type:application/json ${host}/spp/v1/${url} -d @-
}

sppDelete()
{
  url=$1
  curl -sw "\n\n" -k -u ${username}:${password} -X DELETE ${host}/spp/v1/${url}
}

getId()
{
  grep "_id" | sed -e 's/^.*"_id" *: *"//' -e 's/".*$//'
}

registration="{ \"type\" : \"STB\" , \"clientType\" : \"SPECTRUM\" , \"clientVersion\" : \"1.2.5\" , \"hubId\" : ${hubid}, \"isDVR\" : true , \"isHD\" : true , \"isEbifEnabled\" : false , \"hardwareType\" : \"WB\"}"

num=0

while [ $num -lt $count ]; do
  acntnum=$(printf $acntfmt $num)
  acntbody="{ "
  acntbody="${acntbody} \"billingDivisionId\": \"${divid}.${billid}\""
  acntbody="${acntbody}, \"billingAccountId\": \"${billid}:${acntnum}\""
  acntbody="${acntbody}, \"locality\": { \"zipcode\": \"80021\" }"
  acntbody="${acntbody}, \"hubId\": ${hubid}"
  acntbody="${acntbody}, \"divisionCode\": \"${divcode}\""
  acntbody="${acntbody} }"

  acntid=$(echo ${acntbody} | sppPost accounts | getId)

  userbody="{ "
  userbody="${userbody} \"billingDivisionId\": \"${divid}.${billid}\""
  userbody="${userbody}, \"billingAccountId\": \"${billid}:${acntnum}\""
  userbody="${userbody}, \"name\": \"${name}\""
  userbody="${userbody}, \"type\": \"account\""
  userbody="${userbody}, \"roles\": [ \"admin\", \"user\" ]"
  userbody="${userbody} }"

  userid=$(echo ${userbody} | sppPost accounts/${acntid}/users | getId)

  networkid=$(printf $macfmt $num)
  devbody="{ "
  devbody="${devbody} \"type\": \"STB\""
  devbody="${devbody}, \"networkId\": \"${networkid}\""
  devbody="${devbody}, \"divisionCode\": \"${divcode}\""
  devbody="${devbody}, \"registration\": ${registration}"
  devbody="${devbody} }"

  deviceid=$(echo ${devbody} | sppPost users/${userid}/devices | getId)

  sppGet accounts/${acntid}
  sppGet users/${userid}
  sppGet devices/${deviceid}

  if [ $delete ]; then
    sppDelete accounts/${divid}.${billid}:${acntnum}
  fi

  num=$(expr $num + 1)
done
