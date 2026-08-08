# Performance Checklist

- [ ] `ListView.builder` not `ListView(children: huge)`  
- [ ] Images cached / sized  
- [ ] Avoid rebuild storms (select/watch carefully)  
- [ ] Const constructors where possible  
- [ ] Profile with DevTools  
- [ ] No gigantic `setState` at root  
- [ ] Network pagination
