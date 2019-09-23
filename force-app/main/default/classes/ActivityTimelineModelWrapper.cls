global class ActivityTimelineModelWrapper implements Comparable{
    
    public ActivityTimelineModel atv;
    public ActivityTimelineModelWrapper(ActivityTimelineModel atvModel) {
        atvModel = atv;
    }
    
    global Integer compareTo(Object objToCompare){
        
        ActivityTimelineModelWrapper comp = (ActivityTimelineModelWrapper)objToCompare;
        
            if(atv.aInt == comp.atv.aInt ) return 0;
        	if(atv.aInt > comp.atv.aInt) return 1;
            return -1;
    }
}