fx_version 'adamant'

game 'gta5'

data_file 'VEHICLE_LAYOUTS_FILE' 'data/**/vehiclelayouts.meta'
data_file 'HANDLING_FILE' 'data/**/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'data/**/vehicles.meta'
data_file 'CARCOLS_FILE' 'data/**/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'data/**/carvariations.meta'



files {
'data/**/*.meta',
'stream/**/*.meta',
'stream/vehshare.ytd',
}

client_script {
    'vehicle_names.lua' 
}