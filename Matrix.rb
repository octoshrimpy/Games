#cd C:\Ruby193\Scripts


class Matrix

  def initialize
    @tesmat = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15],[16,17,18,19,20]]
    @newmat = Array.new(5) {Array.new(5, "t")}
  end

  def rotate #cw
    ix = 0
    iy = 0
    i = 0
    while iy < @tesmat.length
      @newmat[ix][iy] = @tesmat[iy]
      puts "New x:#{iy} Y:#{ix}, #{@tes_Mat[iy][ix]}"
      ix += 1
      if ix == @tesmat.length
        iy += 1
        ix = 0
      end
    end
    show
  end

  def spin
    i = 0
    ix = 0
    iy = 0
    @a = []
    while iy < @tesmat[0].length
      @a[i] = @tesmat[iy][ix]
      ix += 1
      i += 1
      if ix > @tesmat[0].length
        ix = 0
        iy += 1
      end
    end
  end

  def show
    puts "\nOld: \n\n"

    i = 0
    while i < @tesmat.length
      puts @tesmat[i].join
      i += 1
    end

    puts "\nNew: \n\n"

    i = 0
    while i < @newmat.length
      puts @newmat[i].join
      i += 1
    end
    puts "\na:\n\n"
    puts @a.join
    puts "\n\n"
  end
end

do_stuff = Matrix.new
do_stuff.spin
do_stuff.show
