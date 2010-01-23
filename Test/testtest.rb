require 'dl'

TEST = DL.dlopen('./test.so')
POINT = DL.dlopen('./pointer.so')
test = TEST["example","IP"]
@pointer = POINT["pointer","PP"]

def mypointer(a)
	r,rs=@pointer.call(a);
	return r
end


struct=DL::PtrData.new(0);
struct.free = DL::FREE


r,rs=test.call(struct.ref);

puts r


