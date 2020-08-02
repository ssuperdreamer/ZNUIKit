//
//  ZN_SynthesizeSingleton.h
//  ZNUIKit
//
//  Created by TaKeShi_Mac on 2020/8/2.
//  Copyright © 2020 郑楠楠. All rights reserved.
//

#ifndef ZN_SynthesizeSingleton_h
#define ZN_SynthesizeSingleton_h


#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
    @synchronized(self) \
    { \
        if (shared##classname == nil) \
        { \
            shared##classname = [[self alloc] init]; \
        } \
    } \
    \
    return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
    @synchronized(self) \
    { \
        if (shared##classname == nil) \
        { \
            shared##classname = [super allocWithZone:zone]; \
            return shared##classname; \
        } \
    } \
    \
    return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
    return self; \
} \
\
-(id)mutableCopyWithZone:(NSZone *)zone \
{ \
    return self; \
} \
\
- (id)strong \
{ \
    return self; \
}


#endif /* ZN_SynthesizeSingleton_h */
