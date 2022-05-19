class Observable<T>{

  final T _defaultValue;
  T? _value;
  final List<Function> _callbacks = [];

  Observable(this._defaultValue); // default value (place holder)

  set value(T? value){
    if(_value.hashCode == value.hashCode) return; // prevents recreate view while data is same as old one
    _value = value;
    notifyAll();
  }

  T get value => _value ?? _defaultValue;

  void subscribe(Function callback){
    _callbacks.add(callback);
  }

  void reset(){
    if(_value == null) return;
    _value = null;
    notifyAll();
  }

  void notifyAll(){
    for(Function f in _callbacks){
      f();
    }
  }
}
