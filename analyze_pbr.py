# Python script to analyze OldPBR packs

import os
from PIL import Image, ImageColor

def join_path( r, *p_list ):
    s = r
    for p in p_list:
        s = os.path.join( s, p )
    return s
        

def parse_specular( rp_path, name ):
    spec_path = join_path( rp_path, name + "_s.png" )
    spec = Image.open( spec_path ).convert( "RGBA" )
    spec_data = list( spec.getdata() )
    spec_height = spec.height
    spec_width = spec.width
    spec.close()
    
    img_path = join_path( rp_path, name + ".png" )
    img = None
    img_data = None
    img_width = spec_width
    img_height = spec_height
    if os.path.exists( img_path ):
        img = Image.open( img_path ).convert( "RGBA" )
        img_data = list( img.getdata() )
        if img_width != img.width:
            img_data = None
        if img_height != img.height:
            img_data = None
        img.close()
    total = 0
    smoothness = 0
    metallic = 0
    for y in range( spec_height ):
        for x in range( spec_width ):
            px = spec_data[ y * spec_width + x ]
            a = 1
            if img_data and img_data[ y * img_width + x ][ 3 ] < 26:
                a = 0
            if a:
                r = px[ 0 ]
                g = px[ 1 ]
                smoothness += r
                if g > 128:
                    metallic += 1
                total += 1
    if total == 0:
        return ( 0, 0 )
    smoothness = int( smoothness / total )
    metallic = int( metallic / total * 100 )
    return ( smoothness, metallic )

def parse_rp( base_path ):
    rp_path = join_path( base_path, "assets", "minecraft", "textures", "block" )
    smoothness_dict = {}
    for root, dirs, files in os.walk( rp_path, topdown=False ):
        for name in files:
            split_ext = name.split( '.' )
            if len( split_ext ) == 2:
                if split_ext[ 1 ].lower() == "png":
                    split_type = split_ext[ 0 ].split( "_" )
                    if len( split_type ) > 1:
                        if split_type[ -1 ].lower() == 's':
                            n = "_".join( split_type[ : -1 ] )
                            smoothness, metallic = parse_specular( rp_path, n )
                            if metallic > 50 and metallic < 100:
                                print( name, metallic )
                            #smoothness, metallic = parse_img( join_path( rp_path, name ) )
                            #if smoothness > 128:
                            #   print( name, smoothness )
                        
if __name__ == "__main__":
    parse_rp( "." )