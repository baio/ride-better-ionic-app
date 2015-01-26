FifoArray = (max, elements) ->
  
  # Error checking
  throw new Error("no `max` value provided to FifoArray()")  unless max
  
  # Build the initial elements array
  elements = []  unless elements
  
  # Define the array to be returned
  array = Array.apply(null, [])
  
  # Map of methods to redefine
  redefines = [
    {
      prop: "push"
      trim: "front"
    }
    {
      prop: "unshift"
      trim: "back"
    }
    {
      prop: "splice"
      trim: "back"
    }
  ]
  
  # Process the map
  redefines.forEach (r) ->
    array[r.prop] = ->
      Array::[r.prop].apply this, arguments # apply the original method
      trim = (if (r.trim is "back") then [@max] else [
        0
        @length - max
      ])
      Array::splice.apply this, trim
      return

    Object.defineProperty array, r.prop,
      enumerable: false

    return

  # hide it
  
  # Manage the .max property
  Object.defineProperty array, "max",
    get: ->
      max

    set: (newMax) ->
      max = newMax
      @pop()  while @length > @max # trim when necessary
      return

    enumerable: false # hide it

  
  # now that it's ready, populate the fifoArray with initial elements
  elements.forEach (element) ->
    array.push element
    return

  
  # mmm, bacon!
  array


app.factory "fifoService", ->

   Fifo : FifoArray